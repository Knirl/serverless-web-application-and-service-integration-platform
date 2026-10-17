// Mock data. Delete this file when the real API is connected.
const OPTIONS = {
  categories: ["Hardware", "Software", "Network", "Account Access", "Other"],
  priorities: ["Low", "Medium", "High"],
  statuses: ["Open", "In Progress", "Resolved", "Cancelled"],
};
const daysAgo = (n) => new Date(Date.now() - n * 864e5).toISOString();
const mockRequests = [
  ["Laptop battery drains quickly", "Battery lasts under one hour after the latest update.", "Hardware", "Medium", "Open", 2],
  ["Install design software", "Need Figma desktop app installed for the new project.", "Software", "Low", "In Progress", 5],
  ["VPN disconnects every 10 minutes", "Remote staff lose connection during calls.", "Network", "High", "In Progress", 1],
  ["Password reset for finance portal", "Locked out after three failed attempts.", "Account Access", "High", "Resolved", 6],
  ["Office Wi-Fi slow on 3rd floor", "Speeds under 5 Mbps in the east meeting rooms.", "Network", "Medium", "Open", 3],
  ["Replace broken monitor", "Left monitor shows vertical lines.", "Hardware", "Low", "Resolved", 9],
  ["Request access to shared drive", "New hire needs read access to the Marketing folder.", "Account Access", "Medium", "Open", 1],
  ["Email client crashes on startup", "Crashes immediately after opening since Monday.", "Software", "High", "Open", 0],
  ["Move desk phone extension", "Extension 4021 should follow me to the new desk.", "Other", "Low", "Cancelled", 12],
  ["Printer offline in HR", "Shows offline although it is powered on.", "Hardware", "Medium", "In Progress", 4],
].map(([title, description, category, priority, status, age], i) => ({
  id: "REQ-" + (1001 + i), title, description, category, priority, status,
  createdAt: daysAgo(age + 1), updatedAt: daysAgo(age),
}));
