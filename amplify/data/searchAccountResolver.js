import { util } from "@aws-appsync/utils";

/**
 * Searches for documents by using an input term
 * @param {import('@aws-appsync/utils').Context} ctx the context
 * @returns {*} the request
 */

export function request(ctx) {
  return {
    operation: "GET",
    path: "/account/_search",
    params: {
      headers: {},
      queryString: {},
      body: {
        from: 0,
        size: 10,
        query: {
            multi_match: { 
                query: ctx.args.matchString,
                fields: ['number', 'firstName', 'lastName', 'email'],
                type : 'phrase_prefix',
                lenient: true
            },
        },
      },
    },
  };
}

/**
 * Returns the fetched items
 * @param {import('@aws-appsync/utils').Context} ctx the context
 * @returns {*} the result
 */

export function response(ctx) {
  if (ctx.error) {
    util.error(ctx.error.message, ctx.error.type);
  }
  return ctx.result.hits.hits.map((hit) => hit._source);
}