import { APP_STRINGS } from "@/constants";

export function LoginHeader() {
  return (
    <div className="flex flex-col items-center mb-8">
      <div className="w-12 h-12 bg-primary rounded-xl flex items-center justify-center mb-4 shadow-lg text-primary-foreground font-bold text-xl">
        H
      </div>
      <h1 className="text-2xl font-bold tracking-tight text-foreground">{APP_STRINGS.login.title}</h1>
      <p className="text-sm text-foreground/60 text-center mt-2">{APP_STRINGS.login.subtitle}</p>
    </div>
  );
}
