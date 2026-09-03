import { useState } from "react";
import { useRouter } from "next/navigation";
import { useForm, FieldErrors, UseFormRegister } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { loginSchema, type LoginFormValues } from "@/schemas/auth";
import { useAuthStore } from "@/store/useAuthStore";
import { ApiError } from "@/lib/api";
import { APP_STRINGS } from "@/constants";
import { User } from "@/types/api";
import { Eye, EyeOff } from "lucide-react";
import { useMutation } from "@tanstack/react-query";
import { authService } from "@/services";

async function executeLoginSuccess(token: string, user: User, setAuth: (t: string, u: User) => void, showToast: (msg: string, type: "success"|"error"|"warning") => void, router: ReturnType<typeof useRouter>) {
  await fetch("/api/auth/set-cookie", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ token }),
  });
  setAuth(token, user);
  showToast(APP_STRINGS.login.successMessage, "success");
  setTimeout(() => router.replace("/dashboard"), 1500);
}

function useLoginSubmit(showToast: (msg: string, type: "success"|"error"|"warning") => void) {
  const router = useRouter();
  const setAuth = useAuthStore((state) => state.setAuth);

  const loginMutation = useMutation({
    mutationFn: (data: LoginFormValues) => authService.login({ email: data.email, password: data.password }),
    onSuccess: async (res) => {
      if (res.data.user.role === 'patient') {
        showToast(APP_STRINGS.common.loginPatientError, "error");
        return;
      }
      await executeLoginSuccess(res.data.token, res.data.user, setAuth, showToast, router);
    },
    onError: (err: unknown) => {
      const msg = err instanceof ApiError ? (APP_STRINGS.errors[err.code as keyof typeof APP_STRINGS.errors] || err.message) : APP_STRINGS.login.networkError;
      showToast(msg, "error");
    }
  });

  const onSubmit = (data: LoginFormValues) => {
    loginMutation.mutate(data);
  };

  const onError = (errors: FieldErrors<LoginFormValues>) => {
    if (errors.email?.message === "empty" || errors.password?.message === "empty") {
      showToast(APP_STRINGS.login.emptyFieldsError, "warning");
    } else if (errors.email?.message === "invalid_email") {
      showToast(APP_STRINGS.login.invalidEmailError, "warning");
    }
  };

  return { loading: loginMutation.isPending, onSubmit, onError };
}

function useLoginForm(showToast: (msg: string, type: "success"|"error"|"warning") => void) {
  const [showPassword, setShowPassword] = useState(false);
  const { register, handleSubmit } = useForm<LoginFormValues>({
    resolver: zodResolver(loginSchema),
    defaultValues: { email: "", password: "" },
  });
  return { register, handleSubmit, showPassword, setShowPassword, ...useLoginSubmit(showToast) };
}

function EmailField({ register, loading }: { register: UseFormRegister<LoginFormValues>; loading: boolean }) {
  return (
    <div>
      <label className="block text-xs font-semibold text-foreground/80 mb-2 uppercase tracking-wider">{APP_STRINGS.login.emailLabel}</label>
      <input type="email" {...register("email")} placeholder={APP_STRINGS.login.emailPlaceholder} className="w-full h-11 px-4 rounded-xl border glass-input text-sm text-foreground" disabled={loading} />
    </div>
  );
}

function PasswordField({ register, loading, showPassword, setShowPassword }: { register: UseFormRegister<LoginFormValues>; loading: boolean; showPassword: boolean; setShowPassword: (val: boolean) => void }) {
  return (
    <div>
      <label className="block text-xs font-semibold text-foreground/80 mb-2 uppercase tracking-wider">{APP_STRINGS.login.passwordLabel}</label>
      <div className="relative">
        <input type={showPassword ? "text" : "password"} {...register("password")} placeholder={APP_STRINGS.login.passwordPlaceholder} className="w-full h-11 pl-4 pr-10 rounded-xl border glass-input text-sm text-foreground" disabled={loading} />
        <button type="button" className="absolute inset-y-0 right-0 pr-3 flex items-center text-foreground/50 hover:text-foreground/80" onClick={() => setShowPassword(!showPassword)} disabled={loading}>
          {showPassword ? <EyeOff size={18} /> : <Eye size={18} />}
        </button>
      </div>
    </div>
  );
}

// Migrated to React Query
export function LoginForm({ showToast }: { showToast: (msg: string, type: "success"|"error"|"warning") => void }) {
  const { register, handleSubmit, onSubmit, onError, showPassword, setShowPassword, loading } = useLoginForm(showToast);
  return (
    <form onSubmit={handleSubmit(onSubmit, onError)} className="space-y-5">
      <EmailField register={register} loading={loading} />
      <PasswordField register={register} loading={loading} showPassword={showPassword} setShowPassword={setShowPassword} />
      <button type="submit" disabled={loading} className="w-full h-11 bg-primary hover:bg-primary-hover text-primary-foreground font-medium rounded-xl transition-all duration-200 shadow-md flex items-center justify-center disabled:opacity-50 cursor-pointer">
        {loading ? APP_STRINGS.login.submittingButton : APP_STRINGS.login.submitButton}
      </button>
    </form>
  );
}
