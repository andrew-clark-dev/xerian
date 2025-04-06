"use client";

import CognitoSignInForm from "@/components/auth/CognitoSignInForm";
import { signOut } from 'aws-amplify/auth';
import React from "react";


export default function SignOut() {
  React.useEffect(() => {
    const performSignOut = async () => {
      await signOut();
    };
    performSignOut();
  }, []);

  return <CognitoSignInForm />;
}
