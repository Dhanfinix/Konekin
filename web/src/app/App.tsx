import React, { useState, useEffect } from "react";
import { motion, AnimatePresence } from "motion/react";
import {
  Download,
  Github,
  Wifi,
  Smartphone,
  ShieldAlert,
  Terminal,
  Zap,
  Menu as MenuIcon,
  Copy,
  ChevronDown,
  Command,
  Cable,
  Layers,
  Bot
} from "lucide-react";
import { toast, Toaster } from "sonner";
import konekinIcon from "../assets/konekinIcon.png";
import { ThemeProvider } from "./components/ThemeProvider";
import { ThemeToggle } from "./components/ThemeToggle";

// Apple-esque spring transition
const SPRING = { type: "spring", stiffness: 300, damping: 30 };

function AppContent() {
  const [scrolled, setScrolled] = useState(false);

  useEffect(() => {
    const handleScroll = () => setScrolled(window.scrollY > 50);
    window.addEventListener("scroll", handleScroll);
    return () => window.removeEventListener("scroll", handleScroll);
  }, []);

  return (
    <div className="min-h-screen bg-zinc-50 dark:bg-black text-zinc-900 dark:text-zinc-100 font-sans selection:bg-emerald-500/20 dark:selection:bg-emerald-500/30 selection:text-emerald-900 dark:selection:text-emerald-100 overflow-x-hidden transition-colors duration-300">
      <Toaster position="bottom-center" />

      {/* Dynamic Background Mesh */}
      <div className="fixed inset-0 z-0 pointer-events-none overflow-hidden">
        <div className="absolute top-[-20%] left-[-10%] w-[50vw] h-[50vw] bg-emerald-400/20 dark:bg-emerald-900/20 blur-[120px] rounded-full mix-blend-multiply dark:mix-blend-screen opacity-40 animate-pulse-slow" />
        <div className="absolute bottom-[-20%] right-[-10%] w-[50vw] h-[50vw] bg-blue-400/20 dark:bg-blue-900/10 blur-[120px] rounded-full mix-blend-multiply dark:mix-blend-screen opacity-40" />
      </div>

      {/* Navbar - Floating Pill Style */}
      <nav className={`fixed top-4 left-1/2 -translate-x-1/2 z-50 transition-all duration-300 w-[95%] max-w-5xl ${scrolled ? "top-4" : "top-6"}`}>
        <div className={`
          relative flex items-center justify-between px-4 py-3 rounded-full border 
          ${scrolled
            ? "bg-white/70 dark:bg-zinc-900/70 border-black/5 dark:border-white/10 backdrop-blur-xl shadow-lg shadow-black/5 dark:shadow-black/20"
            : "bg-transparent border-transparent"
          }
        `}>
          <div
            className="flex items-center gap-3 cursor-pointer group"
            onClick={() => window.scrollTo({ top: 0, behavior: 'smooth' })}
          >
            <div className="relative">
              <img src={konekinIcon} alt="Konekin" className="w-8 h-8 rounded-lg shadow-sm group-hover:scale-105 transition-transform" />
              {scrolled && <div className="absolute inset-0 bg-emerald-500/20 blur-lg rounded-full opacity-50" />}
            </div>
            <span className={`font-semibold text-lg tracking-tight transition-opacity ${scrolled ? "opacity-100" : "opacity-0 sm:opacity-100"}`}>
              Konekin
            </span>
          </div>

          <div className="flex items-center gap-2">
            <ThemeToggle />
            <a
              href="https://github.com/Dhanfinix/Konekin"
              target="_blank"
              rel="noopener noreferrer"
              className="p-2 text-zinc-600 dark:text-zinc-400 hover:text-black dark:hover:text-white transition-colors hover:bg-black/5 dark:hover:bg-white/5 rounded-full"
            >
              <Github size={20} />
            </a>
            <AnimatePresence>
              {scrolled && (
                <motion.a
                  initial={{ opacity: 0, scale: 0.9, width: 0 }}
                  animate={{ opacity: 1, scale: 1, width: "auto" }}
                  exit={{ opacity: 0, scale: 0.9, width: 0 }}
                  href="https://github.com/Dhanfinix/Konekin/releases/latest/download/Konekin_Installer.dmg"
                  className="hidden sm:flex bg-zinc-900 dark:bg-white text-white dark:text-black px-4 py-1.5 rounded-full text-sm font-medium hover:bg-zinc-800 dark:hover:bg-zinc-200 transition-colors items-center gap-2 overflow-hidden whitespace-nowrap"
                >
                  <Download size={14} />
                  Get App
                </motion.a>
              )}
            </AnimatePresence>
          </div>
        </div>
      </nav>

      {/* Hero Section */}
      <section className="relative z-10 pt-40 pb-20 px-6">
        <div className="container mx-auto max-w-4xl text-center">
          <motion.div
            initial={{ scale: 0.8, opacity: 0, y: 30 }}
            animate={{ scale: 1, opacity: 1, y: 0 }}
            transition={{ ...SPRING, duration: 1 }}
            className="mb-12 relative inline-flex justify-center"
          >
            <div className="relative group">
              <div className="absolute inset-0 bg-gradient-to-tr from-emerald-500/30 to-blue-500/30 blur-[60px] rounded-full opacity-60 group-hover:opacity-80 transition-opacity duration-1000" />
              <img
                src={konekinIcon}
                alt="Konekin App Icon"
                className="w-40 h-40 md:w-56 md:h-56 rounded-[22.5%] shadow-2xl relative z-10 brightness-110"
                style={{
                  boxShadow: "0 25px 50px -12px rgba(0, 0, 0, 0.25), inset 0 0 0 1px rgba(255, 255, 255, 0.1)"
                }}
              />
            </div>
          </motion.div>

          <motion.h1
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.2, duration: 0.8 }}
            className="text-5xl md:text-7xl font-semibold text-zinc-900 dark:text-white mb-6 tracking-tight leading-tight"
          >
            Seamlessly share Mac <br />
            internet to Android.
          </motion.h1>

          <motion.p
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ delay: 0.4 }}
            className="text-xl md:text-2xl text-zinc-500 dark:text-zinc-400 max-w-2xl mx-auto mb-10 leading-relaxed font-light"
          >
            Reverse tethering made elegant. <br className="hidden sm:block" />
            Connect via USB. Zero configuration. Blazing fast.
          </motion.p>

          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.5 }}
            className="flex flex-col sm:flex-row items-center justify-center gap-4"
          >
            <a
              href="https://github.com/Dhanfinix/Konekin/releases/latest/download/Konekin_Installer.dmg"
              className="group px-8 py-4 bg-zinc-900 dark:bg-white text-white dark:text-black rounded-full font-medium text-lg hover:bg-zinc-800 dark:hover:bg-zinc-200 transition-all flex items-center gap-3 active:scale-95 shadow-lg shadow-zinc-900/10 dark:shadow-white/5"
            >
              <Download size={22} className="group-hover:-translate-y-0.5 transition-transform" />
              Download for macOS
            </a>
            <a
              href="https://github.com/Dhanfinix/Konekin"
              className="group px-8 py-4 bg-white/50 dark:bg-zinc-900/50 backdrop-blur border border-black/5 dark:border-white/10 rounded-full font-medium text-zinc-900 dark:text-white hover:bg-white/80 dark:hover:bg-zinc-800 transition-all flex items-center gap-3 active:scale-95"
            >
              <Github size={22} className="group-hover:rotate-12 transition-transform" />
              Source Code
            </a>
          </motion.div>

          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ delay: 0.8 }}
            className="mt-12 flex items-center justify-center gap-6 text-sm text-zinc-500 dark:text-zinc-500 font-medium"
          >
            <div className="flex items-center gap-2">
              <Command size={14} /> macOS 11.0+
            </div>
            <div className="w-1 h-1 bg-zinc-300 dark:bg-zinc-700 rounded-full" />
            <div className="flex items-center gap-2">
              <Cable size={14} /> USB Required
            </div>
          </motion.div>
        </div>
      </section>

      {/* Bento Grid Features */}
      <section className="py-20 relative z-10">
        <div className="container mx-auto px-6 max-w-5xl">
          <h2 className="text-3xl font-semibold text-zinc-900 dark:text-white mb-12 text-center tracking-tight">Everything you need.</h2>

          <div className="grid grid-cols-1 md:grid-cols-6 gap-6">

            {/* Main Feature - Large Card */}
            <BentoCard className="md:col-span-4 bg-white dark:bg-zinc-900/50 bg-gradient-to-br from-white to-zinc-50 dark:from-zinc-900 dark:to-zinc-950">
              <div className="flex flex-col h-full justify-between">
                <div>
                  <div className="w-12 h-12 rounded-2xl bg-emerald-500/10 dark:bg-emerald-500/20 flex items-center justify-center text-emerald-600 dark:text-emerald-400 mb-6">
                    <Wifi size={24} />
                  </div>
                  <h3 className="text-2xl font-semibold text-zinc-900 dark:text-white mb-2">Reverse Tethering</h3>
                  <p className="text-zinc-500 dark:text-zinc-400 text-lg">
                    Share your Mac's stable ethernet or Wi-Fi connection with your Android device instantly over USB.
                  </p>
                </div>
                <div className="mt-8 h-32 relative overflow-hidden rounded-xl bg-zinc-100 dark:bg-zinc-800/30 border border-black/5 dark:border-white/5 flex items-center justify-center">
                  {/* Abstract Visual for Connectivity */}
                  <div className="flex items-center gap-8 opacity-50">
                    <div className="w-20 h-12 border-2 border-zinc-300 dark:border-zinc-600 rounded-lg flex items-center justify-center text-zinc-600 dark:text-zinc-400 font-medium">Mac</div>
                    <div className="flex gap-1 animate-pulse">
                      <div className="w-2 h-2 bg-emerald-500 rounded-full" />
                      <div className="w-2 h-2 bg-emerald-500 rounded-full delay-75" />
                      <div className="w-2 h-2 bg-emerald-500 rounded-full delay-150" />
                    </div>
                    <div className="w-12 h-20 border-2 border-zinc-300 dark:border-zinc-600 rounded-lg flex items-center justify-center text-zinc-600 dark:text-zinc-400 font-medium">Droid</div>
                  </div>
                </div>
              </div>
            </BentoCard>

            {/* Menu Bar - Tall Card */}
            <BentoCard className="md:col-span-2 bg-white/60 dark:bg-zinc-900/40">
              <div className="w-10 h-10 rounded-xl bg-blue-500/10 dark:bg-blue-500/20 flex items-center justify-center text-blue-600 dark:text-blue-400 mb-4">
                <MenuIcon size={20} />
              </div>
              <h3 className="text-xl font-semibold text-zinc-900 dark:text-white mb-2">Menu Bar Ready</h3>
              <p className="text-zinc-500 dark:text-zinc-400 mb-6">
                Easy access to connection controls and status.
              </p>
              <div className="bg-white dark:bg-zinc-950 rounded-lg p-2 border border-black/5 dark:border-white/10 shadow-xl">
                <div className="flex items-center justify-between px-2 py-1 border-b border-zinc-100 dark:border-white/5 mb-1">
                  <span className="text-[10px] text-zinc-500">Konekin</span>
                  <div className="w-1.5 h-1.5 rounded-full bg-emerald-500" />
                </div>
                <div className="space-y-1">
                  <div className="h-4 w-full bg-zinc-100 dark:bg-zinc-800/50 rounded flex items-center px-2 text-[8px] text-zinc-400">Status: Active</div>
                  <div className="h-4 w-3/4 bg-zinc-100 dark:bg-zinc-800/50 rounded flex items-center px-2 text-[8px] text-zinc-400">Pixel 7 Pro</div>
                </div>
              </div>
            </BentoCard>

            {/* Auto Connect */}
            <BentoCard className="md:col-span-2 bg-white/60 dark:bg-zinc-900/40">
              <div className="w-10 h-10 rounded-xl bg-amber-500/10 dark:bg-amber-500/20 flex items-center justify-center text-amber-600 dark:text-amber-400 mb-4">
                <Zap size={20} />
              </div>
              <h3 className="text-lg font-semibold text-zinc-900 dark:text-white">Auto-Connect</h3>
              <p className="text-zinc-500 dark:text-zinc-500 mt-2 text-sm">
                Automatically detects and connects to new devices.
              </p>
            </BentoCard>

            {/* Multi-Device Support */}
            <BentoCard className="md:col-span-2 bg-white/60 dark:bg-zinc-900/40">
              <div className="w-10 h-10 rounded-xl bg-indigo-500/10 dark:bg-indigo-500/20 flex items-center justify-center text-indigo-600 dark:text-indigo-400 mb-4">
                <Layers size={20} />
              </div>
              <h3 className="text-lg font-semibold text-zinc-900 dark:text-white">Multi-Device</h3>
              <p className="text-zinc-500 dark:text-zinc-500 mt-2 text-sm">
                Select which device to share internet with if multiple are connected.
              </p>
            </BentoCard>

            {/* Privacy */}
            <BentoCard className="md:col-span-2 bg-white/60 dark:bg-zinc-900/40">
              <div className="w-10 h-10 rounded-xl bg-red-500/10 dark:bg-red-500/20 flex items-center justify-center text-red-600 dark:text-red-400 mb-4">
                <ShieldAlert size={20} />
              </div>
              <h3 className="text-lg font-semibold text-zinc-900 dark:text-white">Privacy First</h3>
              <p className="text-zinc-500 dark:text-zinc-500 mt-2 text-sm">
                Warnings about network monitoring on public networks.
              </p>
            </BentoCard>
          </div>
        </div>
      </section>

      {/* Interactive Setup Guide */}
      <section className="py-20 border-t border-black/5 dark:border-white/5 bg-zinc-100/50 dark:bg-zinc-900/20">
        <div className="container mx-auto px-6 max-w-3xl">
          <h2 className="text-3xl font-semibold text-zinc-900 dark:text-white mb-12 text-center tracking-tight">Get started in seconds.</h2>

          <div className="space-y-4">
            <SetupStep
              num="01"
              title="Enable USB Debugging"
              active
            >
              <div className="text-zinc-500 dark:text-zinc-400 space-y-2 pb-4">
                <p>On your Android device:</p>
                <ol className="list-decimal list-inside space-y-1 ml-2 text-sm text-zinc-500 dark:text-zinc-500">
                  <li>Settings → About Phone → Tap "Build Number" 7 times.</li>
                  <li>System → Developer Options.</li>
                  <li>Enable "USB Debugging".</li>
                </ol>
              </div>
            </SetupStep>

            <SetupStep num="02" title="Connect & Authorize">
              <p className="text-zinc-500 dark:text-zinc-400 pb-4 text-sm">
                Plug in your USB cable. Accept the "Allow USB debugging" prompt on your phone screen.
              </p>
            </SetupStep>

            <SetupStep num="03" title="Install Application">
              <div className="pb-4 space-y-4">
                <p className="text-zinc-500 dark:text-zinc-400 text-sm">Download the DMG and drag to Applications.</p>
                <div className="bg-amber-500/10 border border-amber-500/10 p-4 rounded-xl">
                  <div className="flex items-center gap-2 text-amber-600 dark:text-amber-500 mb-2">
                    <ShieldAlert size={14} />
                    <span className="text-xs font-bold uppercase tracking-wider">Fix "App Damaged" Error</span>
                  </div>
                  <div className="bg-white/50 dark:bg-black/50 rounded-lg p-3 flex items-center justify-between group border border-black/5 dark:border-white/5">
                    <code className="font-mono text-xs text-zinc-600 dark:text-zinc-300">xattr -cr /Applications/Konekin.app</code>
                    <button
                      onClick={() => {
                        navigator.clipboard.writeText("xattr -cr /Applications/Konekin.app");
                        toast.success("Command copied");
                      }}
                      className="text-zinc-400 hover:text-zinc-900 dark:text-zinc-500 dark:hover:text-white transition-colors"
                    >
                      <Copy size={14} />
                    </button>
                  </div>
                </div>
              </div>
            </SetupStep>
          </div>
        </div>
      </section>

      {/* Experimental Notice */}
      <section className="py-16 bg-white dark:bg-black border-t border-black/5 dark:border-white/5">
        <div className="container mx-auto px-6 max-w-4xl">
          <div className="rounded-2xl bg-zinc-50 dark:bg-zinc-900 border border-zinc-200 dark:border-zinc-800 p-8 flex flex-col md:flex-row gap-6 items-start">
            <div className="p-3 rounded-full bg-violet-100 dark:bg-violet-900/30 text-violet-600 dark:text-violet-400 shrink-0">
              <Bot size={24} />
            </div>
            <div>
              <h3 className="text-lg font-semibold text-zinc-900 dark:text-white mb-2 flex items-center gap-2">
                Experimental Notice
                <span className="text-[10px] font-bold uppercase tracking-wider bg-violet-100 dark:bg-violet-900/50 text-violet-600 dark:text-violet-300 px-2 py-0.5 rounded-full">AI-Driven</span>
              </h3>
              <p className="text-zinc-500 dark:text-zinc-400 text-sm leading-relaxed mb-4">
                This project is a complete exploration of AI-driven software engineering. Konekin was built entirely through orchestration by Dhanfinix using the Antigravity IDE. Since the codebase is 100% machine-generated across various LLM models, the human orchestrator (Dhanfinix) accepts no responsibility for malfunctions, security gaps, or unexpected behavior.
              </p>
              <p className="text-zinc-400 dark:text-zinc-500 text-xs italic">
                Use this experimental wrapper at your own risk.
              </p>
            </div>
          </div>
        </div>
      </section>

      {/* Footer */}
      <footer className="py-12 border-t border-black/5 dark:border-white/5 bg-zinc-50 dark:bg-zinc-950">
        <div className="container mx-auto px-6 flex flex-col items-center">
          <div className="flex items-center gap-2 mb-6 opacity-50 grayscale hover:grayscale-0 transition-all">
            <img src={konekinIcon} alt="Konekin" className="w-6 h-6 rounded-md" />
            <span className="font-semibold text-zinc-900 dark:text-zinc-300">Konekin</span>
          </div>

          <div className="flex items-center gap-8 text-sm text-zinc-500 dark:text-zinc-500 mb-8">
            <a href="https://github.com/Dhanfinix/Konekin" className="hover:text-black dark:hover:text-white transition-colors">GitHub</a>
            <a href="https://github.com/Dhanfinix/Konekin/releases" className="hover:text-black dark:hover:text-white transition-colors">Releases</a>
            <a href="https://github.com/Dhanfinix/Konekin/issues" className="hover:text-black dark:hover:text-white transition-colors">Support</a>
          </div>

          <p className="text-zinc-400 dark:text-zinc-600 text-xs text-center max-w-md">
            Built with <a href="https://github.com/Genymobile/gnirehtet" className="underline hover:text-zinc-600 dark:hover:text-zinc-400" target="_blank" rel="noreferrer">Gnirehtet</a> by Genymobile for the core reverse tethering functionality. <br />
            Not affiliated with Google or Apple. <br />
            © {new Date().getFullYear()} Dhanfinix. Open Source.
          </p>
        </div>
      </footer>
    </div>
  );
}

export default function App() {
  return (
    <ThemeProvider defaultTheme="system" storageKey="konekin-theme">
      <AppContent />
    </ThemeProvider>
  );
}

// Bento Card Component
function BentoCard({ children, className = "" }: { children: React.ReactNode, className?: string }) {
  return (
    <motion.div
      initial={{ opacity: 0, scale: 0.95 }}
      whileInView={{ opacity: 1, scale: 1 }}
      viewport={{ once: true, margin: "-50px" }}
      transition={{ duration: 0.5 }}
      className={`p-6 rounded-3xl border border-black/5 dark:border-white/5 backdrop-blur-xl hover:border-black/10 dark:hover:border-white/10 transition-colors ${className}`}
    >
      {children}
    </motion.div>
  );
}

// Interactive Step Component
function SetupStep({ num, title, children, active = false }: { num: string, title: string, children: React.ReactNode, active?: boolean }) {
  const [isOpen, setIsOpen] = useState(active);

  return (
    <div className="border border-black/5 dark:border-white/5 bg-white/60 dark:bg-zinc-900/40 rounded-2xl overflow-hidden transition-all hover:bg-white/80 dark:hover:bg-zinc-900/60">
      <button
        onClick={() => setIsOpen(!isOpen)}
        className="w-full flex items-center justify-between p-5 text-left"
      >
        <div className="flex items-center gap-4">
          <span className="font-mono text-zinc-400 dark:text-zinc-600 text-sm">{num}</span>
          <span className="font-medium text-zinc-800 dark:text-zinc-200">{title}</span>
        </div>
        <ChevronDown
          className={`text-zinc-400 dark:text-zinc-500 transition-transform duration-300 ${isOpen ? "rotate-180" : ""}`}
          size={18}
        />
      </button>
      <AnimatePresence>
        {isOpen && (
          <motion.div
            initial={{ height: 0, opacity: 0 }}
            animate={{ height: "auto", opacity: 1 }}
            exit={{ height: 0, opacity: 0 }}
            className="overflow-hidden"
          >
            <div className="px-5 pl-[3.25rem]">
              {children}
            </div>
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  );
}
