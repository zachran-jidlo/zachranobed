import axios, { AxiosError } from 'axios'
// import { FirebaseError } from 'firebase-admin/app'

export const logError = (message: string | undefined, error?: unknown) => {
  if (error instanceof AxiosError) {
    console.error(
      `AXIOS ERROR: ${message}\n${JSON.stringify(error.response?.data)}`
    )
  } else {
    console.error(
      `ERROR: ${message}`,
      error instanceof Error ? error.message : error
    )
  }
}

export const logWarn = (message: string | undefined) => {
  console.error(`WARNING: ${message}`)
}

export const logInfo = (message: string | undefined) => {
  console.info(`INFO: ${message}`)
}

export const logDebug = (message: string | undefined) => {
  console.info(`DEBUG: ${message}`)
}
