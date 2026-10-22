import { LoginClient } from "./Client";
import { Metadata } from "next";

export const metadata: Metadata = {
  title: "Login | Mobatech CRM",
  description: "Login to Mobatech CRM",
};

export default function LoginPage() {
  return (
    <>
      <h1 className="sr-only">Login</h1>
      <LoginClient />
    </>
  );
}
