import * as dotenv from 'dotenv'
import * as url from 'url'

const __dirname = url.fileURLToPath(new URL('.', import.meta.url))

const pathToEnv = __dirname + `../../${process.env.NODE_ENV}.env`

console.debug('Loading enviroment variables at ' + pathToEnv)

// Load environment variables from .env file
dotenv.config({
  path: pathToEnv
})

export const config = {
  NODE_ENV: process.env.NODE_ENV || 'development',
  FIREBASE_PRIVATE_KEY: process.env.FIREBASE_PRIVATE_KEY || '',
  FIREBASE_PROJECT_ID: process.env.FIREBASE_PROJECT_ID || '',
  FIREBASE_CLIENT_EMAIL: process.env.FIREBASE_CLIENT_EMAIL || '',
  DODO_SCOPE: process.env.DODO_SCOPE || '',
  DODO_CLIENT_ID: process.env.DODO_CLIENT_ID || '',
  DODO_CLIENT_SECRET: process.env.DODO_CLIENT_SECRET || '',
  DODO_OAUTH_URI: process.env.DODO_OAUTH_URI || '',
  DODO_ORDERS_API: process.env.DODO_ORDERS_API || '',
  MAKE_API_CALLS: process.env.MAKE_API_CALLS === 'true' || false, // this is because the env value is loaded as a string
  AXIOS_LOGGING_ENABLED: process.env.AXIOS_LOGGING_ENABLED === 'true' || false
}
