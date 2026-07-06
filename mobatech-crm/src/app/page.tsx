import RootRedirect from "@/components/RootRedirect";

export const metadata = { title: "Home | Mobatech CRM", description: "Mobatech CRM Home Management" };

export default function RootPage() {
  return (
    <main className="flex min-h-screen items-center justify-center p-24 bg-background">
      <h1 className="sr-only">Mobatech CRM Home</h1>
      <RootRedirect />
    </main>
  );
}
