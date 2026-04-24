import { z } from 'zod';

export const requestOtpSchema = z.object({
  body: z.object({
    mobile: z.string().regex(/^[6-9]\d{9}$/)
  }),
  query: z.object({}).optional(),
  params: z.object({}).optional()
});

export const verifyOtpSchema = z.object({
  body: z.object({
    mobile: z.string().regex(/^[6-9]\d{9}$/),
    otp: z.string().length(6)
  }),
  query: z.object({}).optional(),
  params: z.object({}).optional()
});
