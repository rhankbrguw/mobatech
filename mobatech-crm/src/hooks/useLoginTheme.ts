import { useState, useEffect } from "react";

export function useLoginTheme() {
  const [dark, setDark] = useState(false);
  const [toast, setToast] = useState<{
    isOpen: boolean;
    message: string;
    type: "success" | "error" | "warning" | "info";
  }>({
    isOpen: false,
    message: "",
    type: "success",
  });

  useEffect(() => {
    setDark(document.documentElement.classList.contains("dark"));
  }, []);

  const toggleTheme = () => {
    const isDark = !dark;
    setDark(isDark);
    if (isDark) {
      document.documentElement.classList.add("dark");
      localStorage.setItem("theme", "dark");
    } else {
      document.documentElement.classList.remove("dark");
      localStorage.setItem("theme", "light");
    }
  };

  const showToast = (message: string, type: "success" | "error" | "warning") => {
    setToast({ isOpen: true, message, type });
  };

  return { dark, toggleTheme, toast, setToast, showToast };
}
