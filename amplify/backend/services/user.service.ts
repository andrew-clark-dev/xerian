import { Schema } from "@schema"; // Adjusted the path to the correct module
import { Logger } from "@aws-lambda-powertools/logger";
import { generateClient } from "aws-amplify/data";

export type UserProfile = Schema['UserProfile']['type'];

const client = generateClient<Schema>();
const logger = new Logger({ serviceName: "user-service" });

interface UserSettings {
  apiKey?: string;
  notifications: boolean;
  theme: 'light' | 'dark';
  hasLogin: false;
}

const initialSettings: UserSettings = {
  notifications: true,
  theme: 'light',
  hasLogin: false,
};


class UserService {

  users: Map<string, UserProfile> = new Map();

  async provisionServiceUser(nickname: string, id: string): Promise<UserProfile> {
    // const existingUser = this.users.get(nickname);
    const { data: existingUser } = await client.models.UserProfile.get({ id: id });
    if (existingUser) { return existingUser }

    const { data: newUserProfile, errors: errors } = await client.models.UserProfile.create(
      {
        id: id,
        status: "Active",
        role: "Service",
        nickname: nickname,
        settings: JSON.stringify(initialSettings),
      }
    );
    if (errors) {
      logger.error(`Failed to create import action - ${JSON.stringify(errors)}`);
      throw new Error(`Failed to create new user profile for : ${nickname} - ${JSON.stringify(errors)}`);
    }
    return newUserProfile!;
  }

  async provisionUser(nickname: string): Promise<UserProfile> {

    const existingUser = this.users.get(nickname);
    if (existingUser) { return existingUser; }

    logger.info(`Provision user : ${nickname} `);

    const { data } = await client.models.UserProfile.listUserProfileByNickname({ nickname: nickname });


    if (data.length > 0) {
      const userProfile = data[0];
      this.users.set(nickname, userProfile);
      logger.info(`User found : ${nickname}`);
      return userProfile;
    } else {
      logger.warn(`User not found - create : ${nickname}`);

      const { data: newUserProfile, errors: errors } = await client.models.UserProfile.create(
        {
          status: "Pending",
          role: "Employee",
          nickname: nickname,
          settings: JSON.stringify(initialSettings),
        }
      );

      if (newUserProfile) {
        const { errors: actionErrors } = await client.models.Action.create({
          description: `Import creating a user profile`,
          modelName: "UserProfile",
          type: "Import",
          typeIndex: "Import",
          refId: newUserProfile.id
        });

        if (actionErrors) {
          logger.error(`Failed to create import action - ${JSON.stringify(actionErrors)}`);
        }

        this.users.set(newUserProfile.id, newUserProfile);

        return newUserProfile;
      } else {
        throw new Error(`Failed to create new user profile for : ${nickname} - ${JSON.stringify(errors)}`);
      }
    }
  }
}

export const userService = new UserService();