import axios, { Axios, AxiosResponse } from 'axios'
import { Number, Record, String, Static, Literal } from 'runtypes'
import { config } from './config.js'
import { logInfo, logWarn } from './logger.js'

export const DodoTokenRT = Record({
  token_type: Literal('Bearer'),
  expires_in: Number,
  ext_expires_in: Number,
  access_token: String
})

const EnvVariablesRT = Record({
  DODO_SCOPE: String,
  DODO_CLIENT_ID: String,
  DODO_CLIENT_SECRET: String,
  DODO_OAUTH_URI: String,
  DODO_ORDERS_API: String
})

export type DODOOrder = {
  id: string
  pickupDodoId: string
  pickupId: string
  pickupFrom: Date
  pickupTo: Date
  pickupNote: string
  deliverId: string
  deliverAddress: string
  deliverFrom: Date
  deliverTo: Date
  deliverNote: string
  customerName: string
  customerPhone: string
}

EnvVariablesRT.check(process.env)

function stringify(obj: any) {
  let cache: any[] | null = []
  const str = JSON.stringify(
    obj,
    function (key, value) {
      if (typeof value === 'object' && value !== null) {
        if (cache?.indexOf(value) !== -1) {
          // Circular reference found, discard key
          return
        }
        // Store value in our collection
        cache?.push(value)
      }
      return value
    },
    2
  )
  cache = null // reset the cache
  return str
}

if (config.AXIOS_LOGGING_ENABLED) {
  logInfo('Axios logging enabled')
  axios.interceptors.request.use((request) => {
    console.log('Starting Request', stringify(request))
    return request
  })

  axios.interceptors.response.use((response) => {
    console.log('Response:', stringify(response))
    return response
  })
}

export type DodoToken = Static<typeof DodoTokenRT>

export const getDodoToken = async (): Promise<any> => {
  if (config.MAKE_API_CALLS === false) {
    console.log('Returning fake token')
    return { access_token: 'fake_token' }
  }

  const params = new URLSearchParams()
  params.append('grant_type', 'client_credentials')
  params.append('scope', config.DODO_SCOPE || '')
  params.append('client_id', config.DODO_CLIENT_ID || '')
  params.append('client_secret', config.DODO_CLIENT_SECRET || '')

  const { data } = await axios.post(config.DODO_OAUTH_URI || '', params)
  return data
}

export const createOrder = async (
  order: DODOOrder,
  token: DodoToken | null
): Promise<AxiosResponse<unknown>> => {
  if (config.MAKE_API_CALLS === false || token === null) {
    return {} as AxiosResponse<unknown>
  }

  return await axios.post(
    process.env.DODO_ORDERS_API || '',
    {
      Identifier: order.id,
      Pickup: {
        BranchIdentifier: order.pickupDodoId,
        RequiredStart: order.pickupFrom.toISOString(),
        RequiredEnd: order.pickupTo.toISOString(),
        Note: order.pickupNote
      },
      Drop: {
        AddressRawValue: order.deliverAddress, // Valid Order address
        RequiredStart: order.deliverFrom.toISOString(),
        RequiredEnd: order.deliverTo.toISOString(),
        Note: order.deliverNote
      },
      CustomerName: order.customerName,
      CustomerPhone: order.customerPhone,
      Price: 0
    },
    {
      headers: { Authorization: `Bearer ${token.access_token || ''}` },
      timeout: 30000
    }
  )
}

export const cancelDodoOrder = async (
  deliveryIdentifier: string,
  token: DodoToken | null
): Promise<AxiosResponse<unknown>> => {
  logWarn(`! Cancelling DODO order ${deliveryIdentifier}`)
  if (config.MAKE_API_CALLS === false || token === null) {
    return {} as AxiosResponse<unknown>
  }

  return await axios.put(
    `${config.DODO_ORDERS_API}/${encodeURIComponent(
      deliveryIdentifier
    )}/status`,
    {
      Status: 'Cancelled',
      Reason: 'Delivery was not confirmed in time',
      StatusChangeTime: new Date().toISOString()
    },
    {
      headers: { Authorization: `Bearer ${token.access_token || ''}` },
      timeout: 30000
    }
  )
}
