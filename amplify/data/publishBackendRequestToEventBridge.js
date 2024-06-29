export function request(ctx) {
    return {
      operation: "PutEvents",
      events: [
        {
          source: "amplify.backend-requests",
          ["detail-type"]: "BackendRequest",
          detail: { ...ctx.args },
        },
      ],
    };
  }
  
  export function response(ctx) {
    return ctx.args;
  }