"use client";
import React, { useState, useRef, useEffect } from "react";
import { createPortal } from "react-dom";
import { MoreVertical } from "lucide-react";

export interface ActionMenuItem {
  label: string;
  icon?: React.ReactNode;
  onClick: () => void;
  variant?: "default" | "danger" | "success" | "warning" | "info";
  disabled?: boolean;
}

export function ActionMenu({ items }: { items: ActionMenuItem[] }) {
  const [isOpen, setIsOpen] = useState(false);
  const [coords, setCoords] = useState({ top: 0, right: 0 });
  const buttonRef = useRef<HTMLButtonElement>(null);
  const dropdownRef = useRef<HTMLDivElement>(null);

  
  const toggleMenu = (e: React.MouseEvent) => {
    e.stopPropagation();
    if (!isOpen && buttonRef.current) {
      const rect = buttonRef.current.getBoundingClientRect();
      // Position it exactly below the button
      setCoords({
        top: rect.bottom + window.scrollY + 5,
        right: window.innerWidth - rect.right,
      });
    }
    setIsOpen(!isOpen);
  };

  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      if (
        dropdownRef.current && 
        !dropdownRef.current.contains(event.target as Node) &&
        buttonRef.current &&
        !buttonRef.current.contains(event.target as Node)
      ) {
        setIsOpen(false);
      }
    };
    
    const handleScroll = () => {
      if (isOpen) setIsOpen(false); // Close on scroll to prevent floating dropdown misalignment
    };

    if (isOpen) {
      document.addEventListener("mousedown", handleClickOutside);
      window.addEventListener("scroll", handleScroll, true);
    }
    return () => {
      document.removeEventListener("mousedown", handleClickOutside);
      window.removeEventListener("scroll", handleScroll, true);
    };
  }, [isOpen]);

  const dropdown = isOpen ? (
    <div
      ref={dropdownRef}
      style={{ top: coords.top, right: coords.right }}
      className="fixed z-[9999] w-48 rounded-xl shadow-2xl bg-surface-primary/95 dark:bg-[#0c2219]/95 backdrop-blur-2xl border border-glass-border p-1 overflow-hidden animate-slide-in origin-top-right ring-1 ring-black/5 dark:ring-white/10"
    >
      <div className="flex flex-col gap-0.5">
        {items.map((item, index) => (
          <button
            key={index}
            disabled={item.disabled}
            onClick={(e) => {
              e.stopPropagation();
              item.onClick();
              setIsOpen(false);
            }}
            className={`w-full text-left px-3 py-2 text-xs font-medium flex items-center gap-2.5 rounded-lg transition-colors cursor-pointer
              ${item.disabled ? "opacity-40 cursor-not-allowed" : "hover:bg-overlay-dark dark:hover:bg-white/5 active:scale-[0.98]"}
              ${!item.variant || item.variant === "default" ? "text-foreground/80 hover:text-foreground" : ""}
              ${item.variant === "danger" ? "text-error hover:bg-error-muted" : ""}
              ${item.variant === "success" ? "text-success hover:bg-success-muted" : ""}
              ${item.variant === "info" ? "text-info hover:bg-info-muted" : ""}
              ${item.variant === "warning" ? "text-warning hover:bg-warning-muted" : ""}
            `}
          >
            <span className={item.variant === "danger" ? "text-error" : "text-foreground/60"}>
              {item.icon}
            </span>
            <span>{item.label}</span>
          </button>
        ))}
      </div>
    </div>
  ) : null;

  return (
    <>
      <button
        ref={buttonRef}
        onClick={toggleMenu}
        aria-label="Aksi"
        className={`w-8 h-8 rounded-lg flex items-center justify-center transition-all duration-200 border cursor-pointer ${
          isOpen
            ? "bg-primary/15 border-primary/40 text-primary shadow-sm"
            : "border-glass-border bg-overlay-dark/40 dark:bg-overlay-light/40 hover:bg-primary/10 hover:border-primary/30 text-foreground/70 hover:text-primary active:scale-95"
        }`}
      >
        <MoreVertical size={16} />
      </button>
      {/* Render dropdown via portal to body to completely escape overflow-x hidden/auto clipping */}
      {typeof document !== "undefined" && dropdown ? createPortal(dropdown, document.body) : null}
    </>
  );
}
