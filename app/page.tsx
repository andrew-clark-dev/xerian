"use client";

import { useState, useEffect } from "react";
import { generateClient } from "aws-amplify/data";
import type { Schema } from "@/amplify/data/resource";
import "./../app/app.css";
import { Amplify } from "aws-amplify";
import outputs from "@/amplify_outputs.json";
import "@aws-amplify/ui-react/styles.css";

Amplify.configure(outputs);

const client = generateClient<Schema>();

export default function App() {
  const [accounts, setAccounts] = useState<Array<Schema["Account"]["type"]>>([]);

  function listAccounts() {
    client.models.Account.observeQuery().subscribe({
      next: (data) => setAccounts([...data.items]),
    });
  }

  useEffect(() => {
    listAccounts();
  }, []);

  function createAccount() {
    // client.models.Account.create({
    //   content: window.prompt("Account content"),
    // });
  }

  return (
    <main>
      <h1>My accounts</h1>
      <button onClick={createAccount}>+ new</button>
      <ul>
        {accounts.map((account) => (
          <li key={account.id}>{account.lastName}</li>
        ))}
      </ul>
      <div>
        🥳 App successfully hosted. Try creating a new account.
        <br />
        <a href="https://docs.amplify.aws/nextjs/start/quickstart/nextjs-app-router-client-components/">
          Review next steps of this tutorial.
        </a>
      </div>
    </main>
  );
}
