import { DashboardClient } from "./Client";
import { Metadata } from "next";

export const metadata: Metadata = {
  title: "Dashboard | Mobatech CRM",
  description: "Mobatech CRM Dashboard",
};

export default function DashboardPage() {
  return (
    <>
      <h1 className="sr-only">Dashboard</h1>
      <DashboardClient />
    </>
  );
}
