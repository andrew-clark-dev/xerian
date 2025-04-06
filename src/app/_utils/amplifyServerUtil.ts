import { createServerRunner } from "@aws-amplify/adapter-nextjs";
import { cookies } from "next/headers";
import { getCurrentUser } from "aws-amplify/auth/server";
import outputs from '../../../amplify_outputs.json';

export const { runWithAmplifyServerContext } = createServerRunner({ config: outputs });

export const isAuthenticated = async () =>
  await runWithAmplifyServerContext({
    nextServerContext: { cookies },
    async operation(contextSpec) {
      try {
        const user = await getCurrentUser(contextSpec);
        return !!user;
      } catch {
        return false;
      }
    },
  });