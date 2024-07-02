/**
 * Sends an event to Event Bridge
 * @param {import('@aws-appsync/utils').Context} ctx the context
 * @returns {*} the request
 */
export function request(ctx) {
    return {
        operation: 'PutEvents',
        events: [
            {
                source: ctx.args.source,
                detail: {payload: ctx.args.payload},
                detailType: 'ClientRequest',
                time: util.time.nowISO8601(),
            },
        ],
    };
}


/**
 * Process the response
 * @param {import('@aws-appsync/utils').Context} ctx the context
 * @returns {*} the EventBridge response
 */
export function response(ctx) {
    return ctx.result;
}