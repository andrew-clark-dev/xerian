import { getAmplifyDataClientConfig } from '@aws-amplify/backend/function/runtime';
import { Amplify } from "aws-amplify";
import { generateClient } from "aws-amplify/data";
import { Schema } from "../data/resource";
import { DataClientEnv } from '@aws-amplify/backend-function/runtime';


export async function getClient(env: DataClientEnv) {
    const { resourceConfig, libraryOptions } = await getAmplifyDataClientConfig(env);

    Amplify.configure(resourceConfig, libraryOptions);

    const client = generateClient<Schema>();
    return client;
}

export async function configureAmplify(env: DataClientEnv) {
    const { resourceConfig, libraryOptions } = await getAmplifyDataClientConfig(env);

    Amplify.configure(resourceConfig, libraryOptions);

}
