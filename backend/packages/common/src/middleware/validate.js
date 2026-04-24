import { BadRequestError } from '../errors/custom-error.js';

export const validate = (schema) => (req, res, next) => {
  try {
    schema.parse({
      body: req.body,
      query: req.query,
      params: req.params,
    });
    next();
  } catch (error) {
    const message = error.errors.map((e) => `${e.path.join('.')}: ${e.message}`).join(', ');
    next(new BadRequestError(message));
  }
};
