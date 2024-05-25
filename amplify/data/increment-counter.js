// https://docs.amplify.aws/flutter/build-a-backend/data/custom-business-logic/
export function request(ctx) {
    return {
      operation: 'UpdateItem',
      key: util.dynamodb.toMapValues({ id: ctx.args.id}),
      update: {
        expression: 'ADD #count :plusOne',
        expressionNames: {"#count": "count"},
        expressionValues: { ':plusOne': { N: 1 } },
      }
    }
  }
  
  export function response(ctx) {
    const { error, result } = ctx;
	if (error) {
		return util.error(error.message, error.type);
	}
	return result;
  }