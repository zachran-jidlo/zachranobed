import {z} from "zod";

export const DodoTokenSchema = z.object({
  /** Token type, always "Bearer" */
  token_type: z.literal("Bearer"),
  /** Token expiration in seconds */
  expires_in: z.number(),
  /** Extended expiration in seconds */
  ext_expires_in: z.number(),
  /** Access token for API requests */
  access_token: z.string(),
});

export type DodoToken = z.infer<typeof DodoTokenSchema>;
