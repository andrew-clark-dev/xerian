import { defineBackend } from '@aws-amplify/backend';
import { auth } from './auth/resource';
import { data } from './data/resource';

/**
 * @see https://docs.amplify.aws/react/build-a-backend/ to add storage, functions, and more
 */
const backend = defineBackend({
  auth,
  data,
});


// extract L1 CfnUserPool resources
const { cfnUserPool } = backend.auth.resources.cfnResources;
// use CDK's `addPropertyOverride` to modify properties directly
cfnUserPool.addPropertyOverride(
  "Policies",
  {
    PasswordPolicy: {
      MinimumLength: 20,
      RequireLowercase: false,
      RequireNumbers: false,
      RequireSymbols: false,
      RequireUppercase: false,
      TemporaryPasswordValidityDays: 20,
    },
  }
);