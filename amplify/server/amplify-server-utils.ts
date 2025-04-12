// utils/amplify-utils.ts
import { cookies } from "next/headers";

import { createServerRunner } from "@aws-amplify/adapter-nextjs";
import { generateServerClientUsingCookies } from "@aws-amplify/adapter-nextjs/api";
import { fetchAuthSession, getCurrentUser } from "aws-amplify/auth/server";

import { type Schema } from '../../amplify/data/resource'
import outputs from '../../amplify_outputs.json';

export const { runWithAmplifyServerContext } = createServerRunner({
  config: outputs,
});

export const serverClient = generateServerClientUsingCookies<Schema>({
  config: outputs,
  cookies,
});

export const currentUser = async () =>
  await runWithAmplifyServerContext({
    nextServerContext: { cookies },
    async operation(contextSpec) {
      try {
        const user = await getCurrentUser(contextSpec);
        return user;
      } catch {
        return null;
      }
    },
  });

export const authenticated = async () =>
  await runWithAmplifyServerContext({
    nextServerContext: { cookies },
    operation: async (contextSpec) => {
      try {
        const session = await fetchAuthSession(contextSpec, {});
        return session.tokens !== undefined;
      } catch (error) {
        console.log(error);
        return false;
      }
    },
  });