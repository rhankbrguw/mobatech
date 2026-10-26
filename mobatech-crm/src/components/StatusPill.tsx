import React from "react";

const STATUS_COLOR: Record<string, { bg: string; text: string; dot: string }> = {
  pending:        { bg: "bg-warning-muted",  text: "text-warning",  dot: "bg-warning" },
  menunggu:       { bg: "bg-warning-muted",  text: "text-warning",  dot: "bg-warning" },
  unpaid:         { bg: "bg-warning-muted",  text: "text-warning",  dot: "bg-warning" },
  approved:       { bg: "bg-info-muted",    text: "text-info",    dot: "bg-info"   },
  disetujui:      { bg: "bg-info-muted",    text: "text-info",    dot: "bg-info"   },
  processing:     { bg: "bg-info-muted",    text: "text-info",    dot: "bg-info"   },
  ready:          { bg: "bg-accent-muted",  text: "text-accent",  dot: "bg-accent" },
  tersedia:       { bg: "bg-accent-muted",  text: "text-accent",  dot: "bg-accent" },
  available:      { bg: "bg-accent-muted",  text: "text-accent",  dot: "bg-accent" },
  completed:      { bg: "bg-success-muted",   text: "text-success",   dot: "bg-success"  },
  selesai:        { bg: "bg-success-muted",   text: "text-success",   dot: "bg-success"  },
  active:         { bg: "bg-success-muted",   text: "text-success",   dot: "bg-success"  },
  aktif:          { bg: "bg-success-muted",   text: "text-success",   dot: "bg-success"  },
  paid:           { bg: "bg-success-muted",   text: "text-success",   dot: "bg-success"  },
  cancelled:      { bg: "bg-error-muted",     text: "text-error",     dot: "bg-error"    },
  dibatalkan:     { bg: "bg-error-muted",     text: "text-error",     dot: "bg-error"    },
  unavailable:    { bg: "bg-error-muted",     text: "text-error",     dot: "bg-error"    },
  dispatched:     { bg: "bg-info-muted",  text: "text-info",  dot: "bg-info" },
  arrived:        { bg: "bg-teal-muted",    text: "text-teal",    dot: "bg-teal"   },
  resolved:       { bg: "bg-neutral-muted",    text: "text-neutral",    dot: "bg-neutral"   },
  redeemed:       { bg: "bg-neutral-muted",    text: "text-neutral",    dot: "bg-neutral"   },
  refunded:       { bg: "bg-neutral-muted",    text: "text-neutral",    dot: "bg-neutral"   },
};

export function StatusPill({ status }: { status: string }) {
  const s = STATUS_COLOR[status?.toLowerCase()] ?? { bg: "bg-neutral-muted", text: "text-neutral", dot: "bg-neutral" };
  return (
    <span className={`inline-flex items-center gap-1.5 px-2 py-0.5 rounded-full text-xs font-medium uppercase tracking-wider ${s.bg} ${s.text}`}>
      <span className={`w-1.5 h-1.5 rounded-full ${s.dot}`} />
      {status}
    </span>
  );
}
