import React from "react";
import { Moon, Sun, Monitor, Laptop } from "lucide-react";
import { useTheme } from "./ThemeProvider";
import { motion, AnimatePresence } from "motion/react";

export function ThemeToggle() {
  const { theme, setTheme } = useTheme();
  const [isOpen, setIsOpen] = React.useState(false);

  return (
    <div className="relative">
      <button
        onClick={() => setIsOpen(!isOpen)}
        className="p-2 rounded-full hover:bg-black/5 dark:hover:bg-white/5 transition-colors text-zinc-600 dark:text-zinc-400"
        aria-label="Toggle theme"
      >
        <Sun className="h-[1.2rem] w-[1.2rem] rotate-0 scale-100 transition-all dark:-rotate-90 dark:scale-0" />
        <Moon className="absolute top-2 left-2 h-[1.2rem] w-[1.2rem] rotate-90 scale-0 transition-all dark:rotate-0 dark:scale-100" />
      </button>

      <AnimatePresence>
        {isOpen && (
          <>
            <div 
              className="fixed inset-0 z-40" 
              onClick={() => setIsOpen(false)} 
            />
            <motion.div
              initial={{ opacity: 0, scale: 0.9, y: 10 }}
              animate={{ opacity: 1, scale: 1, y: 0 }}
              exit={{ opacity: 0, scale: 0.9, y: 10 }}
              className="absolute right-0 mt-2 w-32 rounded-xl bg-white/80 dark:bg-zinc-900/80 backdrop-blur-xl border border-black/5 dark:border-white/5 shadow-xl z-50 overflow-hidden"
            >
              <div className="flex flex-col p-1">
                <button
                  onClick={() => { setTheme("light"); setIsOpen(false); }}
                  className={`flex items-center gap-2 px-3 py-2 text-sm rounded-lg transition-colors ${
                    theme === "light" 
                      ? "bg-black/5 dark:bg-white/10 text-black dark:text-white font-medium" 
                      : "text-zinc-600 dark:text-zinc-400 hover:bg-black/5 dark:hover:bg-white/5"
                  }`}
                >
                  <Sun size={16} />
                  <span>Light</span>
                </button>
                <button
                  onClick={() => { setTheme("dark"); setIsOpen(false); }}
                  className={`flex items-center gap-2 px-3 py-2 text-sm rounded-lg transition-colors ${
                    theme === "dark" 
                      ? "bg-black/5 dark:bg-white/10 text-black dark:text-white font-medium" 
                      : "text-zinc-600 dark:text-zinc-400 hover:bg-black/5 dark:hover:bg-white/5"
                  }`}
                >
                  <Moon size={16} />
                  <span>Dark</span>
                </button>
                <button
                  onClick={() => { setTheme("system"); setIsOpen(false); }}
                  className={`flex items-center gap-2 px-3 py-2 text-sm rounded-lg transition-colors ${
                    theme === "system" 
                      ? "bg-black/5 dark:bg-white/10 text-black dark:text-white font-medium" 
                      : "text-zinc-600 dark:text-zinc-400 hover:bg-black/5 dark:hover:bg-white/5"
                  }`}
                >
                  <Laptop size={16} />
                  <span>System</span>
                </button>
              </div>
            </motion.div>
          </>
        )}
      </AnimatePresence>
    </div>
  );
}
