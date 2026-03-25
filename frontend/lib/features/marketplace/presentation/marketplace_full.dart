import { useState, useRef, useEffect } from "react";

// ── COLORS ──────────────────────────────────────────────
const C = {
  primary: "#E30613",
  dark: "#1A1A1A",
  grey: "#888888",
  lightGrey: "#F5F5F5",
  border: "#EEEEEE",
  white: "#FFFFFF",
  green: "#10B981",
  amber: "#F59E0B",
};

// ── INITIAL DATA ─────────────────────────────────────────
const INITIAL_PRODUCTS = [
  { id: "p1", name: "HP Laptop 15.6\"", brand: "HP", price: 5200, oldPrice: 6500, rating: 4.5, reviews: 124, emoji: "💻", category: "Electronics", description: "HP 15.6\" Intel Core i5, 8GB RAM, 512GB SSD, Windows 11. Perfect for students.", isNew: false, isSale: true, seller: "Precious Mhd", sellerId: "u2", university: "UCT" },
  { id: "p2", name: "iPhone 12 Pro Max", brand: "Apple", price: 12500, oldPrice: 15000, rating: 4.8, reviews: 87, emoji: "📱", category: "Electronics", description: "128GB, Midnight Black. Excellent condition, comes with charger and box.", isNew: true, isSale: false, seller: "Sipho M.", sellerId: "u3", university: "Wits" },
  { id: "p3", name: "SkullCandy Headphone", brand: "SkullCandy", price: 1200, oldPrice: 1800, rating: 4.6, reviews: 56, emoji: "🎧", category: "Electronics", description: "Over-ear wireless headphones, 40hr battery, foldable design.", isNew: true, isSale: false, seller: "Aisha K.", sellerId: "u4", university: "UP" },
  { id: "p4", name: "Study Mini Table", brand: "FurniCo", price: 780, oldPrice: 1100, rating: 4.1, reviews: 34, emoji: "🪑", category: "Furniture", description: "Portable laptop table with adjustable height, great for dorm rooms.", isNew: false, isSale: false, seller: "Zanele D.", sellerId: "u5", university: "UJ" },
  { id: "p5", name: "Macbook 16", brand: "Apple", price: 18900, oldPrice: 22000, rating: 4.9, reviews: 203, emoji: "💻", category: "Electronics", description: "M1 Pro chip, 16GB RAM, 512GB SSD. Near-new condition.", isNew: false, isSale: true, seller: "Keanu N.", sellerId: "u6", university: "CPUT" },
  { id: "p6", name: "Casio Scientific Calculator", brand: "Casio", price: 245, oldPrice: 350, rating: 4.9, reviews: 312, emoji: "🧮", category: "Stationery", description: "FX-991ZA PLUS — go-to for SA university maths and science.", isNew: false, isSale: true, seller: "Ruan P.", sellerId: "u7", university: "SU" },
  { id: "p7", name: "Russell Hobbs Air Fryer", brand: "Russell Hobbs", price: 2100, oldPrice: 2800, rating: 4.2, reviews: 45, emoji: "🍳", category: "Appliances", description: "4.5L digital air fryer. Barely used, perfect for student cooking.", isNew: false, isSale: true, seller: "Fatima H.", sellerId: "u8", university: "UKZN" },
  { id: "p8", name: "Desktop Monitor 24\"", brand: "Samsung", price: 3800, oldPrice: 4500, rating: 4.4, reviews: 67, emoji: "🖥️", category: "Electronics", description: "Full HD IPS panel, 75Hz, HDMI & VGA ports.", isNew: false, isSale: false, seller: "Ntando B.", sellerId: "u9", university: "UWC" },
];

const INITIAL_SERVICES = [
  { id: "s1", name: "Mathematics Tutoring", description: "Grade 10–12 & university maths, stats, and calculus", price: "R120/hr", emoji: "📐", category: "Academic", provider: "Sipho M.", providerId: "u3", university: "Wits", rating: 4.9, reviews: 34, isFeatured: true },
  { id: "s2", name: "Essay Writing Coaching", description: "Structure, grammar, referencing & academic writing", price: "R100/hr", emoji: "✍️", category: "Academic", provider: "Aisha K.", providerId: "u4", university: "UP", rating: 4.7, reviews: 22, isFeatured: false },
  { id: "s3", name: "Graphic Design", description: "Logos, posters, social media content & branding", price: "R200/job", emoji: "🎨", category: "Creative", provider: "Yusuf A.", providerId: "u10", university: "TUT", rating: 4.7, reviews: 53, isFeatured: true },
  { id: "s4", name: "Coding & Programming Help", description: "Python, Java, C++, web dev and data science", price: "R150/hr", emoji: "💻", category: "Academic", provider: "Keanu N.", providerId: "u6", university: "CPUT", rating: 4.8, reviews: 41, isFeatured: true },
  { id: "s5", name: "CV & Cover Letter Writing", description: "Professional CVs tailored to SA job market", price: "R180/CV", emoji: "📄", category: "Professional", provider: "Priya S.", providerId: "u11", university: "NMU", rating: 4.8, reviews: 62, isFeatured: true },
  { id: "s6", name: "Photography", description: "Events, portraits, product & campus photography", price: "R350/session", emoji: "📷", category: "Creative", provider: "Nandi M.", providerId: "u12", university: "DUT", rating: 4.9, reviews: 37, isFeatured: true },
  { id: "s7", name: "Video Editing", description: "YouTube, reels, TikTok, corporate & event edits", price: "R250/video", emoji: "🎬", category: "Digital", provider: "Thabo G.", providerId: "u13", university: "VUT", rating: 4.7, reviews: 31, isFeatured: false },
  { id: "s8", name: "IT & Tech Support", description: "Laptop repair, software setup & virus removal", price: "R120/hr", emoji: "🔧", category: "Digital", provider: "Imran R.", providerId: "u14", university: "CUT", rating: 4.7, reviews: 29, isFeatured: false },
  { id: "s9", name: "Home Cleaning", description: "Student digs and apartment cleaning service", price: "R150/visit", emoji: "🧹", category: "Lifestyle", provider: "Bongani L.", providerId: "u15", university: "MUT", rating: 4.4, reviews: 16, isFeatured: false },
  { id: "s10", name: "Delivery & Errands", description: "Campus deliveries, grocery runs & courier tasks", price: "R50/trip", emoji: "🛵", category: "Lifestyle", provider: "Khanya M.", providerId: "u16", university: "UFS", rating: 4.2, reviews: 44, isFeatured: false },
];

const PRODUCT_CATEGORIES = ["All", "Electronics", "Furniture", "Stationery", "Appliances", "Books", "Clothes", "Bags"];
const SERVICE_CATEGORIES = ["All", "Academic", "Creative", "Digital", "Professional", "Lifestyle"];

const INITIAL_MESSAGES = {
  "u2": [{ from: "u2", text: "Hi! I still have the laptop available. When would you like to pick it up?", time: "10:30 AM" }],
  "u3": [{ from: "u3", text: "Yes, I offer tutoring sessions on weekdays 4-8PM. What subject do you need help with?", time: "Yesterday" }],
};

const NOTIFICATIONS = [
  { id: 1, text: "Sipho M. replied to your message", time: "2 min ago", read: false },
  { id: 2, text: "Your order for HP Laptop was confirmed", time: "1 hr ago", read: false },
  { id: 3, text: "New service available: Music Lessons near you", time: "3 hrs ago", read: true },
  { id: 4, text: "Price drop on Macbook 16 — now R18,900", time: "Yesterday", read: true },
];

// ── UTILITIES ────────────────────────────────────────────
function formatPrice(n) { return `R${Number(n).toLocaleString("en-ZA")}`; }

function Avatar({ name, size = 32, bg = C.primary }) {
  return (
    <div style={{ width: size, height: size, borderRadius: "50%", background: bg, display: "flex", alignItems: "center", justifyContent: "center", flexShrink: 0 }}>
      <span style={{ color: "#fff", fontWeight: 700, fontSize: size * 0.4 }}>{(name || "?")[0].toUpperCase()}</span>
    </div>
  );
}

function Badge({ label, color = C.primary, bg }) {
  return (
    <span style={{ background: bg || color + "18", color, fontSize: 9, fontWeight: 700, padding: "2px 6px", borderRadius: 4, letterSpacing: 0.3 }}>{label}</span>
  );
}

function StarRow({ rating, size = 11 }) {
  return (
    <span style={{ display: "inline-flex", alignItems: "center", gap: 2 }}>
      <span style={{ color: C.amber, fontSize: size }}>★</span>
      <span style={{ fontSize: size, fontWeight: 600, color: C.dark }}>{rating.toFixed(1)}</span>
    </span>
  );
}

// ── CART ────────────────────────────────────────────────
function useCart() {
  const [items, setItems] = useState([]);
  const add = (product) => setItems(prev => {
    const ex = prev.find(i => i.product.id === product.id);
    if (ex) return prev.map(i => i.product.id === product.id ? { ...i, qty: i.qty + 1 } : i);
    return [...prev, { product, qty: 1 }];
  });
  const remove = (id) => setItems(prev => prev.filter(i => i.product.id !== id));
  const updateQty = (id, qty) => setItems(prev => qty <= 0 ? prev.filter(i => i.product.id !== id) : prev.map(i => i.product.id === id ? { ...i, qty } : i));
  const clear = () => setItems([]);
  const total = items.reduce((s, i) => s + i.product.price * i.qty, 0);
  const count = items.reduce((s, i) => s + i.qty, 0);
  return { items, add, remove, updateQty, clear, total, count };
}

// ── MESSAGING ───────────────────────────────────────────
function MessagingPanel({ conversations, onSend, currentUser = "me", onClose }) {
  const [activeConv, setActiveConv] = useState(null);
  const [draft, setDraft] = useState("");
  const msgEndRef = useRef(null);

  useEffect(() => { msgEndRef.current?.scrollIntoView({ behavior: "smooth" }); }, [activeConv, conversations]);

  const convKeys = Object.keys(conversations);

  const sendMsg = () => {
    if (!draft.trim() || !activeConv) return;
    onSend(activeConv, draft.trim());
    setDraft("");
  };

  return (
    <div style={{ position: "fixed", inset: 0, background: "rgba(0,0,0,0.4)", zIndex: 200, display: "flex", alignItems: "flex-end", justifyContent: "center" }}>
      <div style={{ background: C.white, width: "100%", maxWidth: 480, height: "85vh", borderRadius: "16px 16px 0 0", display: "flex", flexDirection: "column", overflow: "hidden" }}>
        {/* Header */}
        <div style={{ padding: "14px 16px", borderBottom: `1px solid ${C.border}`, display: "flex", alignItems: "center", gap: 10 }}>
          {activeConv && (
            <button onClick={() => setActiveConv(null)} style={{ background: "none", border: "none", cursor: "pointer", padding: 4, color: C.dark }}>←</button>
          )}
          <div style={{ flex: 1, fontWeight: 700, fontSize: 15, color: C.dark }}>
            {activeConv ? (conversations[activeConv]?.name || "Chat") : "Messages"}
          </div>
          <button onClick={onClose} style={{ background: "none", border: "none", cursor: "pointer", fontSize: 18, color: C.grey }}>✕</button>
        </div>

        {!activeConv ? (
          /* Inbox list */
          <div style={{ flex: 1, overflowY: "auto" }}>
            {convKeys.length === 0 && (
              <div style={{ textAlign: "center", color: C.grey, padding: 40 }}>No messages yet</div>
            )}
            {convKeys.map(uid => {
              const conv = conversations[uid];
              const lastMsg = conv.messages[conv.messages.length - 1];
              const unread = conv.messages.filter(m => m.from !== "me" && !m.read).length;
              return (
                <div key={uid} onClick={() => setActiveConv(uid)} style={{ display: "flex", alignItems: "center", gap: 12, padding: "12px 16px", borderBottom: `1px solid ${C.border}`, cursor: "pointer" }}>
                  <Avatar name={conv.name} size={42} />
                  <div style={{ flex: 1, minWidth: 0 }}>
                    <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center" }}>
                      <span style={{ fontWeight: 700, fontSize: 13, color: C.dark }}>{conv.name}</span>
                      <span style={{ fontSize: 10, color: C.grey }}>{lastMsg?.time || ""}</span>
                    </div>
                    <div style={{ fontSize: 12, color: C.grey, overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>
                      {lastMsg ? (lastMsg.from === "me" ? "You: " : "") + lastMsg.text : "Start a conversation"}
                    </div>
                  </div>
                  {unread > 0 && (
                    <div style={{ background: C.primary, color: "#fff", borderRadius: "50%", width: 18, height: 18, display: "flex", alignItems: "center", justifyContent: "center", fontSize: 10, fontWeight: 700, flexShrink: 0 }}>{unread}</div>
                  )}
                </div>
              );
            })}
          </div>
        ) : (
          /* Chat thread */
          <>
            <div style={{ flex: 1, overflowY: "auto", padding: "12px 16px", display: "flex", flexDirection: "column", gap: 8 }}>
              {(conversations[activeConv]?.messages || []).map((msg, i) => {
                const isMe = msg.from === "me";
                return (
                  <div key={i} style={{ display: "flex", justifyContent: isMe ? "flex-end" : "flex-start" }}>
                    <div style={{ maxWidth: "72%", background: isMe ? C.primary : C.lightGrey, color: isMe ? "#fff" : C.dark, borderRadius: isMe ? "16px 4px 16px 16px" : "4px 16px 16px 16px", padding: "10px 14px", fontSize: 13 }}>
                      <div>{msg.text}</div>
                      <div style={{ fontSize: 10, opacity: 0.7, marginTop: 4, textAlign: "right" }}>{msg.time}</div>
                    </div>
                  </div>
                );
              })}
              <div ref={msgEndRef} />
            </div>
            <div style={{ padding: "10px 12px", borderTop: `1px solid ${C.border}`, display: "flex", gap: 8, alignItems: "center" }}>
              <input
                value={draft}
                onChange={e => setDraft(e.target.value)}
                onKeyDown={e => e.key === "Enter" && sendMsg()}
                placeholder="Type a message…"
                style={{ flex: 1, border: `1px solid ${C.border}`, borderRadius: 20, padding: "10px 14px", fontSize: 13, outline: "none" }}
              />
              <button onClick={sendMsg} style={{ background: C.primary, color: "#fff", border: "none", borderRadius: "50%", width: 38, height: 38, cursor: "pointer", fontSize: 16 }}>➤</button>
            </div>
          </>
        )}
      </div>
    </div>
  );
}

// ── NOTIFICATIONS PANEL ───────────────────────────────────
function NotificationsPanel({ notifications, onClose, onMarkAll }) {
  return (
    <div style={{ position: "fixed", inset: 0, zIndex: 200, background: "rgba(0,0,0,0.3)", display: "flex", alignItems: "flex-start", justifyContent: "flex-end" }}>
      <div style={{ background: C.white, width: 320, maxHeight: "80vh", borderRadius: "0 0 16px 16px", boxShadow: "0 8px 32px rgba(0,0,0,0.12)", display: "flex", flexDirection: "column", marginTop: 56 }}>
        <div style={{ padding: "14px 16px", borderBottom: `1px solid ${C.border}`, display: "flex", justifyContent: "space-between", alignItems: "center" }}>
          <span style={{ fontWeight: 700, fontSize: 15 }}>Notifications</span>
          <div style={{ display: "flex", gap: 8, alignItems: "center" }}>
            <button onClick={onMarkAll} style={{ background: "none", border: "none", color: C.primary, fontSize: 11, cursor: "pointer", fontWeight: 600 }}>Mark all read</button>
            <button onClick={onClose} style={{ background: "none", border: "none", cursor: "pointer", fontSize: 16, color: C.grey }}>✕</button>
          </div>
        </div>
        <div style={{ overflowY: "auto" }}>
          {notifications.map(n => (
            <div key={n.id} style={{ padding: "12px 16px", borderBottom: `1px solid ${C.border}`, display: "flex", gap: 10, alignItems: "flex-start", background: n.read ? C.white : "#FFF5F5" }}>
              <div style={{ width: 8, height: 8, borderRadius: "50%", background: n.read ? C.border : C.primary, marginTop: 5, flexShrink: 0 }} />
              <div>
                <div style={{ fontSize: 13, color: C.dark }}>{n.text}</div>
                <div style={{ fontSize: 11, color: C.grey, marginTop: 2 }}>{n.time}</div>
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}

// ── CART PANEL ────────────────────────────────────────────
function CartPanel({ cart, onClose }) {
  const [step, setStep] = useState(0); // 0=cart 1=checkout 2=success
  const [tab, setTab] = useState(0);

  if (step === 2) return (
    <div style={{ position: "fixed", inset: 0, background: "rgba(0,0,0,0.4)", zIndex: 200, display: "flex", alignItems: "center", justifyContent: "center" }}>
      <div style={{ background: C.white, width: "90%", maxWidth: 400, borderRadius: 20, padding: 32, textAlign: "center" }}>
        <div style={{ fontSize: 60, marginBottom: 16 }}>🎉</div>
        <div style={{ fontWeight: 800, fontSize: 20, color: C.dark, marginBottom: 8 }}>Order Placed!</div>
        <div style={{ color: C.grey, fontSize: 13, marginBottom: 24 }}>Thank you for shopping at Gude! Your order is being processed.</div>
        <button onClick={() => { cart.clear(); onClose(); }} style={{ background: C.primary, color: "#fff", border: "none", borderRadius: 12, padding: "14px 32px", fontWeight: 700, cursor: "pointer", width: "100%" }}>Continue Shopping</button>
      </div>
    </div>
  );

  return (
    <div style={{ position: "fixed", inset: 0, background: "rgba(0,0,0,0.4)", zIndex: 200, display: "flex", alignItems: "flex-end", justifyContent: "center" }}>
      <div style={{ background: C.white, width: "100%", maxWidth: 480, height: "90vh", borderRadius: "16px 16px 0 0", display: "flex", flexDirection: "column" }}>
        {/* AppBar */}
        <div style={{ padding: "14px 16px", borderBottom: `1px solid ${C.border}`, display: "flex", alignItems: "center", justifyContent: "space-between" }}>
          <button onClick={onClose} style={{ background: "none", border: "none", cursor: "pointer", color: C.dark, fontSize: 18 }}>←</button>
          <span style={{ fontWeight: 700, fontSize: 16, color: C.dark }}>
            {step === 0 ? "My Cart" : "Checkout"}
          </span>
          <button onClick={onClose} style={{ background: "none", border: "none", cursor: "pointer", fontSize: 16, color: C.grey }}>✕</button>
        </div>

        {step === 0 && (
          <>
            {/* Tabs */}
            <div style={{ display: "flex", borderBottom: `1px solid ${C.border}` }}>
              {["My Cart", "Wishlist"].map((t, i) => (
                <button key={i} onClick={() => setTab(i)} style={{ flex: 1, padding: "12px", background: "none", border: "none", borderBottom: `2px solid ${tab === i ? C.primary : "transparent"}`, color: tab === i ? C.primary : C.grey, fontWeight: 600, cursor: "pointer", fontSize: 13 }}>{t}</button>
              ))}
            </div>

            {tab === 1 ? (
              <div style={{ flex: 1, display: "flex", alignItems: "center", justifyContent: "center", flexDirection: "column", gap: 8, color: C.grey }}>
                <span style={{ fontSize: 48 }}>🤍</span>
                <div>Wishlist coming soon</div>
              </div>
            ) : cart.items.length === 0 ? (
              <div style={{ flex: 1, display: "flex", alignItems: "center", justifyContent: "center", flexDirection: "column", gap: 8, color: C.grey }}>
                <span style={{ fontSize: 48 }}>🛒</span>
                <div style={{ fontWeight: 700, fontSize: 15 }}>Your cart is empty</div>
                <div style={{ fontSize: 12 }}>Start browsing the marketplace</div>
                <button onClick={onClose} style={{ marginTop: 12, background: C.primary, color: "#fff", border: "none", borderRadius: 10, padding: "10px 24px", cursor: "pointer", fontWeight: 600 }}>Explore</button>
              </div>
            ) : (
              <>
                <div style={{ flex: 1, overflowY: "auto", padding: 16, display: "flex", flexDirection: "column", gap: 12 }}>
                  {cart.items.map(item => (
                    <div key={item.product.id} style={{ background: C.white, border: `1px solid ${C.border}`, borderRadius: 14, display: "flex", overflow: "hidden" }}>
                      <div style={{ width: 80, background: C.lightGrey, display: "flex", alignItems: "center", justifyContent: "center", fontSize: 36, flexShrink: 0 }}>
                        {item.product.emoji}
                      </div>
                      <div style={{ flex: 1, padding: "12px 12px 12px 12px", display: "flex", flexDirection: "column", gap: 4 }}>
                        <div style={{ fontSize: 12, fontWeight: 700, color: C.dark, lineHeight: 1.3 }}>{item.product.name}</div>
                        <div style={{ fontSize: 13, fontWeight: 800, color: C.primary }}>{formatPrice(item.product.price)}</div>
                        <div style={{ display: "flex", alignItems: "center", gap: 8, marginTop: 4 }}>
                          <button onClick={() => cart.updateQty(item.product.id, item.qty - 1)} style={{ width: 24, height: 24, border: `1px solid ${C.border}`, borderRadius: 6, background: C.white, cursor: "pointer", display: "flex", alignItems: "center", justifyContent: "center", fontWeight: 700 }}>−</button>
                          <span style={{ fontWeight: 700, fontSize: 13 }}>{item.qty}</span>
                          <button onClick={() => cart.updateQty(item.product.id, item.qty + 1)} style={{ width: 24, height: 24, border: "none", borderRadius: 6, background: C.primary, color: "#fff", cursor: "pointer", display: "flex", alignItems: "center", justifyContent: "center", fontWeight: 700 }}>+</button>
                        </div>
                      </div>
                      <button onClick={() => cart.remove(item.product.id)} style={{ background: "none", border: "none", color: C.border, fontSize: 18, cursor: "pointer", padding: "0 12px" }}>🗑</button>
                    </div>
                  ))}
                </div>
                {/* Order summary */}
                <div style={{ padding: 16, borderTop: `1px solid ${C.border}`, background: C.white }}>
                  <div style={{ display: "flex", justifyContent: "space-between", fontSize: 13, color: C.grey, marginBottom: 4 }}><span>Subtotal</span><span style={{ color: C.dark }}>{formatPrice(cart.total)}</span></div>
                  <div style={{ display: "flex", justifyContent: "space-between", fontSize: 13, color: C.grey, marginBottom: 8 }}><span>Shipping</span><span style={{ color: C.green }}>FREE</span></div>
                  <div style={{ display: "flex", justifyContent: "space-between", fontWeight: 800, fontSize: 15, color: C.dark, marginBottom: 12 }}><span>Total</span><span style={{ color: C.primary }}>{formatPrice(cart.total)}</span></div>
                  <button onClick={() => setStep(1)} style={{ width: "100%", background: C.primary, color: "#fff", border: "none", borderRadius: 12, padding: "14px", fontWeight: 700, cursor: "pointer", fontSize: 14 }}>
                    Proceed to Checkout ({cart.count})
                  </button>
                </div>
              </>
            )}
          </>
        )}

        {step === 1 && (
          <>
            {/* Step indicator */}
            <div style={{ display: "flex", justifyContent: "center", gap: 4, padding: "12px 16px", borderBottom: `1px solid ${C.border}` }}>
              {["Shipping", "Payment", "Review"].map((s, i) => (
                <div key={i} style={{ display: "flex", alignItems: "center", gap: 4 }}>
                  <div style={{ width: 26, height: 26, borderRadius: "50%", background: i <= 1 ? C.primary : C.border, color: "#fff", display: "flex", alignItems: "center", justifyContent: "center", fontSize: 12, fontWeight: 700 }}>{i + 1}</div>
                  <span style={{ fontSize: 10, color: i <= 1 ? C.primary : C.grey, fontWeight: 600 }}>{s}</span>
                  {i < 2 && <div style={{ width: 20, height: 1, background: C.border }} />}
                </div>
              ))}
            </div>
            <div style={{ flex: 1, overflowY: "auto", padding: 16 }}>
              <div style={{ fontWeight: 700, fontSize: 14, color: C.dark, marginBottom: 12 }}>Shipping Address</div>
              {[["Full Name", "Enter full name"], ["Phone", "+27 xx xxx xxxx"], ["Address", "Street address"], ["City", "City"], ["Postal Code", "Postal code"]].map(([label, ph]) => (
                <div key={label} style={{ marginBottom: 12 }}>
                  <div style={{ fontSize: 12, color: C.grey, marginBottom: 4 }}>{label}</div>
                  <input placeholder={ph} style={{ width: "100%", border: `1px solid ${C.border}`, borderRadius: 10, padding: "10px 12px", fontSize: 13, outline: "none", boxSizing: "border-box" }} />
                </div>
              ))}
              <div style={{ fontWeight: 700, fontSize: 14, color: C.dark, marginBottom: 12, marginTop: 16 }}>Payment Method</div>
              {["Gude Wallet", "Credit/Debit Card", "EFT / Instant Pay"].map((m, i) => (
                <div key={m} style={{ display: "flex", alignItems: "center", gap: 12, padding: "14px", border: `1px solid ${i === 0 ? C.primary : C.border}`, borderRadius: 12, marginBottom: 10, cursor: "pointer", background: i === 0 ? "#FFF5F5" : C.white }}>
                  <span style={{ fontSize: 18 }}>{["👛", "💳", "🏦"][i]}</span>
                  <span style={{ fontWeight: 600, fontSize: 13, color: i === 0 ? C.primary : C.dark }}>{m}</span>
                  {i === 0 && <span style={{ marginLeft: "auto", background: C.primary + "18", color: C.primary, fontSize: 10, fontWeight: 700, padding: "2px 8px", borderRadius: 4 }}>Selected</span>}
                </div>
              ))}
            </div>
            <div style={{ padding: 16, borderTop: `1px solid ${C.border}` }}>
              <button onClick={() => setStep(2)} style={{ width: "100%", background: C.primary, color: "#fff", border: "none", borderRadius: 12, padding: "14px", fontWeight: 700, cursor: "pointer", fontSize: 14 }}>Place Order</button>
            </div>
          </>
        )}
      </div>
    </div>
  );
}

// ── CREATE POST MODAL ─────────────────────────────────────
function CreatePostModal({ onClose, onSubmit }) {
  const [tab, setTab] = useState(0); // 0=product 1=service
  const [form, setForm] = useState({ title: "", description: "", price: "", category: "Electronics", images: [], condition: "Good", location: "" });
  const [serviceForm, setServiceForm] = useState({ name: "", description: "", price: "", category: "Academic" });
  const [imgPreviews, setImgPreviews] = useState([]);
  const fileRef = useRef();

  const handleImages = (e) => {
    const files = Array.from(e.target.files);
    files.forEach(f => {
      const reader = new FileReader();
      reader.onload = ev => setImgPreviews(prev => [...prev, ev.target.result]);
      reader.readAsDataURL(f);
    });
    setForm(p => ({ ...p, images: [...p.images, ...files] }));
  };

  const submit = () => {
    if (tab === 0) {
      if (!form.title || !form.price) return alert("Please fill in Title and Price");
      onSubmit({ type: "product", ...form, imgPreviews });
    } else {
      if (!serviceForm.name || !serviceForm.price) return alert("Please fill in Name and Price");
      onSubmit({ type: "service", ...serviceForm });
    }
    onClose();
  };

  return (
    <div style={{ position: "fixed", inset: 0, background: "rgba(0,0,0,0.45)", zIndex: 300, display: "flex", alignItems: "flex-end", justifyContent: "center" }}>
      <div style={{ background: C.white, width: "100%", maxWidth: 480, maxHeight: "92vh", borderRadius: "16px 16px 0 0", display: "flex", flexDirection: "column", overflow: "hidden" }}>
        <div style={{ padding: "14px 16px", borderBottom: `1px solid ${C.border}`, display: "flex", alignItems: "center", justifyContent: "space-between" }}>
          <span style={{ fontWeight: 700, fontSize: 16, color: C.dark }}>Create a Post</span>
          <button onClick={onClose} style={{ background: "none", border: "none", cursor: "pointer", fontSize: 18, color: C.grey }}>✕</button>
        </div>

        {/* Tab */}
        <div style={{ display: "flex", borderBottom: `1px solid ${C.border}` }}>
          {["Sell Items", "Offer Services"].map((t, i) => (
            <button key={i} onClick={() => setTab(i)} style={{ flex: 1, padding: "11px", background: "none", border: "none", borderBottom: `2px solid ${tab === i ? C.primary : "transparent"}`, color: tab === i ? C.primary : C.grey, fontWeight: 600, cursor: "pointer", fontSize: 13 }}>{t}</button>
          ))}
        </div>

        <div style={{ flex: 1, overflowY: "auto", padding: 16 }}>
          {tab === 0 ? (
            <>
              {/* Image Upload */}
              <div style={{ marginBottom: 14 }}>
                <div style={{ fontSize: 12, color: C.grey, marginBottom: 6, fontWeight: 600 }}>Product Images</div>
                <div style={{ display: "flex", gap: 8, flexWrap: "wrap" }}>
                  {imgPreviews.map((src, i) => (
                    <div key={i} style={{ width: 72, height: 72, borderRadius: 10, overflow: "hidden", position: "relative" }}>
                      <img src={src} alt="" style={{ width: "100%", height: "100%", objectFit: "cover" }} />
                      <button onClick={() => { setImgPreviews(p => p.filter((_, j) => j !== i)); }} style={{ position: "absolute", top: 2, right: 2, background: C.primary, color: "#fff", border: "none", borderRadius: "50%", width: 16, height: 16, fontSize: 9, cursor: "pointer", display: "flex", alignItems: "center", justifyContent: "center" }}>✕</button>
                    </div>
                  ))}
                  <button onClick={() => fileRef.current.click()} style={{ width: 72, height: 72, border: `2px dashed ${C.border}`, borderRadius: 10, background: C.lightGrey, display: "flex", flexDirection: "column", alignItems: "center", justifyContent: "center", cursor: "pointer", gap: 4, color: C.grey, fontSize: 10 }}>
                    <span style={{ fontSize: 22 }}>📷</span>Upload
                  </button>
                </div>
                <input ref={fileRef} type="file" multiple accept="image/*" style={{ display: "none" }} onChange={handleImages} />
              </div>

              {[["Title", "title", "e.g. HP Laptop 15\""], ["Price (R)", "price", "e.g. 5200"], ["Location", "location", "e.g. Johannesburg, Gauteng"]].map(([label, key, ph]) => (
                <div key={key} style={{ marginBottom: 12 }}>
                  <div style={{ fontSize: 12, color: C.grey, marginBottom: 4, fontWeight: 600 }}>{label}</div>
                  <input value={form[key]} onChange={e => setForm(p => ({ ...p, [key]: e.target.value }))} placeholder={ph} style={{ width: "100%", border: `1px solid ${C.border}`, borderRadius: 10, padding: "10px 12px", fontSize: 13, outline: "none", boxSizing: "border-box" }} />
                </div>
              ))}

              <div style={{ marginBottom: 12 }}>
                <div style={{ fontSize: 12, color: C.grey, marginBottom: 4, fontWeight: 600 }}>Category</div>
                <select value={form.category} onChange={e => setForm(p => ({ ...p, category: e.target.value }))} style={{ width: "100%", border: `1px solid ${C.border}`, borderRadius: 10, padding: "10px 12px", fontSize: 13, outline: "none" }}>
                  {PRODUCT_CATEGORIES.filter(c => c !== "All").map(c => <option key={c}>{c}</option>)}
                </select>
              </div>

              <div style={{ marginBottom: 12 }}>
                <div style={{ fontSize: 12, color: C.grey, marginBottom: 4, fontWeight: 600 }}>Condition</div>
                <div style={{ display: "flex", gap: 8 }}>
                  {["New", "Like New", "Good", "Fair"].map(c => (
                    <button key={c} onClick={() => setForm(p => ({ ...p, condition: c }))} style={{ flex: 1, padding: "8px 4px", border: `1px solid ${form.condition === c ? C.primary : C.border}`, borderRadius: 8, background: form.condition === c ? C.primary + "10" : C.white, color: form.condition === c ? C.primary : C.grey, fontSize: 11, fontWeight: 600, cursor: "pointer" }}>{c}</button>
                  ))}
                </div>
              </div>

              <div style={{ marginBottom: 12 }}>
                <div style={{ fontSize: 12, color: C.grey, marginBottom: 4, fontWeight: 600 }}>Description</div>
                <textarea value={form.description} onChange={e => setForm(p => ({ ...p, description: e.target.value }))} placeholder="Describe your item…" rows={3} style={{ width: "100%", border: `1px solid ${C.border}`, borderRadius: 10, padding: "10px 12px", fontSize: 13, outline: "none", resize: "vertical", boxSizing: "border-box" }} />
              </div>

              <div style={{ marginBottom: 12 }}>
                <div style={{ fontSize: 12, color: C.grey, marginBottom: 4, fontWeight: 600 }}>Serial Number (optional)</div>
                <input placeholder="Put valid serial for verification" style={{ width: "100%", border: `1px solid ${C.border}`, borderRadius: 10, padding: "10px 12px", fontSize: 13, outline: "none", boxSizing: "border-box" }} />
              </div>
            </>
          ) : (
            <>
              {[["Service Name", "name", "e.g. Maths Tutoring"], ["Price", "price", "e.g. R120/hr"], ["Description", "description", "Describe your service…"]].map(([label, key, ph]) => (
                <div key={key} style={{ marginBottom: 12 }}>
                  <div style={{ fontSize: 12, color: C.grey, marginBottom: 4, fontWeight: 600 }}>{label}</div>
                  {key === "description" ? (
                    <textarea value={serviceForm[key]} onChange={e => setServiceForm(p => ({ ...p, [key]: e.target.value }))} placeholder={ph} rows={3} style={{ width: "100%", border: `1px solid ${C.border}`, borderRadius: 10, padding: "10px 12px", fontSize: 13, outline: "none", resize: "vertical", boxSizing: "border-box" }} />
                  ) : (
                    <input value={serviceForm[key]} onChange={e => setServiceForm(p => ({ ...p, [key]: e.target.value }))} placeholder={ph} style={{ width: "100%", border: `1px solid ${C.border}`, borderRadius: 10, padding: "10px 12px", fontSize: 13, outline: "none", boxSizing: "border-box" }} />
                  )}
                </div>
              ))}
              <div style={{ marginBottom: 12 }}>
                <div style={{ fontSize: 12, color: C.grey, marginBottom: 4, fontWeight: 600 }}>Category</div>
                <select value={serviceForm.category} onChange={e => setServiceForm(p => ({ ...p, category: e.target.value }))} style={{ width: "100%", border: `1px solid ${C.border}`, borderRadius: 10, padding: "10px 12px", fontSize: 13, outline: "none" }}>
                  {SERVICE_CATEGORIES.filter(c => c !== "All").map(c => <option key={c}>{c}</option>)}
                </select>
              </div>
              <div style={{ marginBottom: 12 }}>
                <div style={{ fontSize: 12, color: C.grey, marginBottom: 4, fontWeight: 600 }}>Availability</div>
                <div style={{ display: "flex", gap: 6, flexWrap: "wrap" }}>
                  {["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"].map(d => (
                    <button key={d} style={{ padding: "6px 10px", border: `1px solid ${C.border}`, borderRadius: 6, background: C.lightGrey, color: C.grey, fontSize: 12, cursor: "pointer" }}>{d}</button>
                  ))}
                </div>
              </div>
            </>
          )}
        </div>

        <div style={{ padding: 16, borderTop: `1px solid ${C.border}` }}>
          <button onClick={submit} style={{ width: "100%", background: C.primary, color: "#fff", border: "none", borderRadius: 12, padding: "14px", fontWeight: 700, cursor: "pointer", fontSize: 14 }}>
            Submit {tab === 0 ? "Listing" : "Service"}
          </button>
        </div>
      </div>
    </div>
  );
}

// ── PRODUCT DETAIL ────────────────────────────────────────
function ProductDetail({ item, onBack, onAddToCart, onMessage }) {
  const [qty, setQty] = useState(1);
  const discount = item.oldPrice ? Math.round((item.oldPrice - item.price) / item.oldPrice * 100) : 0;

  return (
    <div style={{ background: C.white, minHeight: "100vh", display: "flex", flexDirection: "column" }}>
      <div style={{ padding: "12px 16px", borderBottom: `1px solid ${C.border}`, display: "flex", alignItems: "center", gap: 10 }}>
        <button onClick={onBack} style={{ background: "none", border: "none", cursor: "pointer", fontSize: 18, color: C.dark }}>←</button>
        <span style={{ fontWeight: 700, fontSize: 16, color: C.dark }}>Product Details</span>
      </div>

      <div style={{ flex: 1, overflowY: "auto" }}>
        {/* Hero */}
        <div style={{ background: C.lightGrey, height: 260, display: "flex", alignItems: "center", justifyContent: "center", position: "relative" }}>
          {item.imgPreviews?.[0] ? (
            <img src={item.imgPreviews[0]} alt="" style={{ width: "100%", height: "100%", objectFit: "cover" }} />
          ) : (
            <span style={{ fontSize: 100 }}>{item.emoji || "📦"}</span>
          )}
          {discount > 0 && <div style={{ position: "absolute", top: 12, left: 12, background: C.primary, color: "#fff", borderRadius: 8, padding: "4px 10px", fontSize: 11, fontWeight: 700 }}>-{discount}%</div>}
          {item.isNew && <div style={{ position: "absolute", top: 12, left: 12, background: C.green, color: "#fff", borderRadius: 8, padding: "4px 10px", fontSize: 11, fontWeight: 700 }}>NEW</div>}
        </div>

        {/* Multiple images row */}
        {item.imgPreviews?.length > 1 && (
          <div style={{ display: "flex", gap: 8, padding: "8px 16px", overflowX: "auto" }}>
            {item.imgPreviews.map((src, i) => (
              <img key={i} src={src} alt="" style={{ width: 60, height: 60, borderRadius: 8, objectFit: "cover", flexShrink: 0, border: `2px solid ${i === 0 ? C.primary : C.border}` }} />
            ))}
          </div>
        )}

        <div style={{ padding: 16 }}>
          <div style={{ fontWeight: 800, fontSize: 18, color: C.dark }}>{item.name}</div>
          <div style={{ color: C.grey, fontSize: 13, marginTop: 2 }}>{item.brand || item.category}</div>

          <div style={{ display: "flex", alignItems: "baseline", gap: 8, marginTop: 10 }}>
            <span style={{ fontSize: 22, fontWeight: 900, color: C.primary }}>{formatPrice(item.price)}</span>
            {item.oldPrice && <span style={{ fontSize: 14, color: C.grey, textDecoration: "line-through" }}>{formatPrice(item.oldPrice)}</span>}
          </div>

          {item.rating && (
            <div style={{ display: "flex", alignItems: "center", gap: 6, marginTop: 8 }}>
              {[1,2,3,4,5].map(s => <span key={s} style={{ color: s <= Math.floor(item.rating) ? C.amber : C.border, fontSize: 16 }}>★</span>)}
              <span style={{ fontSize: 12, color: C.grey }}>{item.rating} ({item.reviews} reviews)</span>
            </div>
          )}

          {item.description && (
            <>
              <div style={{ fontWeight: 700, fontSize: 13, color: C.dark, marginTop: 16, marginBottom: 6 }}>Description</div>
              <div style={{ fontSize: 13, color: "#555", lineHeight: 1.6 }}>{item.description}</div>
            </>
          )}

          {/* Seller */}
          {item.seller && (
            <>
              <div style={{ fontWeight: 700, fontSize: 13, color: C.dark, marginTop: 16, marginBottom: 8 }}>Seller</div>
              <div style={{ background: C.lightGrey, borderRadius: 12, border: `1px solid ${C.border}`, padding: 12, display: "flex", alignItems: "center", gap: 10 }}>
                <Avatar name={item.seller} size={40} />
                <div style={{ flex: 1 }}>
                  <div style={{ fontWeight: 700, fontSize: 13 }}>{item.seller}</div>
                  <div style={{ fontSize: 11, color: C.grey }}>{item.university} · Product Owner</div>
                </div>
                <button onClick={() => onMessage(item.sellerId, item.seller)} style={{ background: C.primary + "18", border: "none", borderRadius: 8, padding: "8px 12px", color: C.primary, cursor: "pointer", fontSize: 12, fontWeight: 600 }}>💬 Chat</button>
              </div>
            </>
          )}

          {/* Verify */}
          <div style={{ marginTop: 16 }}>
            <div style={{ fontWeight: 700, fontSize: 13, color: C.dark, marginBottom: 6 }}>Verify this Product</div>
            <input placeholder="Enter serial number here…" style={{ width: "100%", border: `1px solid ${C.border}`, borderRadius: 10, padding: "10px 12px", fontSize: 13, outline: "none", boxSizing: "border-box" }} />
          </div>
          <div style={{ height: 90 }} />
        </div>
      </div>

      {/* Bottom bar */}
      <div style={{ padding: "12px 16px 24px", borderTop: `1px solid ${C.border}`, background: C.white, display: "flex", gap: 12 }}>
        <div style={{ border: `1px solid ${C.border}`, borderRadius: 10, display: "flex", alignItems: "center" }}>
          <button onClick={() => setQty(q => Math.max(1, q - 1))} style={{ padding: "8px 14px", background: "none", border: "none", cursor: "pointer", fontWeight: 700, fontSize: 16 }}>−</button>
          <span style={{ fontWeight: 700, minWidth: 20, textAlign: "center" }}>{qty}</span>
          <button onClick={() => setQty(q => q + 1)} style={{ padding: "8px 14px", background: "none", border: "none", cursor: "pointer", fontWeight: 700, fontSize: 16 }}>+</button>
        </div>
        <button onClick={() => { for(let i=0;i<qty;i++) onAddToCart(item); onBack(); }} style={{ flex: 1, background: C.primary, color: "#fff", border: "none", borderRadius: 12, padding: "14px", fontWeight: 700, cursor: "pointer", fontSize: 14 }}>
          Add to Cart ({qty})
        </button>
      </div>
    </div>
  );
}

// ── SERVICE DETAIL ────────────────────────────────────────
function ServiceDetail({ service, onBack, onMessage }) {
  return (
    <div style={{ background: C.white, minHeight: "100vh", display: "flex", flexDirection: "column" }}>
      <div style={{ padding: "12px 16px", display: "flex", alignItems: "center", gap: 10, borderBottom: `1px solid ${C.border}` }}>
        <button onClick={onBack} style={{ background: "none", border: "none", cursor: "pointer", fontSize: 18, color: C.dark }}>←</button>
        <span style={{ fontWeight: 700, fontSize: 16, color: C.dark }}>Service Details</span>
      </div>

      {/* Hero */}
      <div style={{ background: C.primary, padding: 32, display: "flex", flexDirection: "column", alignItems: "center", gap: 8 }}>
        <Avatar name={service.provider} size={72} bg="rgba(255,255,255,0.2)" />
        <div style={{ fontWeight: 800, fontSize: 18, color: "#fff" }}>{service.provider}</div>
        <div style={{ color: "rgba(255,255,255,0.8)", fontSize: 13 }}>{service.university}</div>
      </div>

      <div style={{ flex: 1, overflowY: "auto", padding: 16 }}>
        <div style={{ background: C.white, border: `1px solid ${C.border}`, borderRadius: 12, padding: 16, marginBottom: 12 }}>
          <div style={{ fontWeight: 800, fontSize: 18, color: C.dark }}>{service.name}</div>
          <div style={{ display: "flex", gap: 16, marginTop: 10 }}>
            <StarRow rating={service.rating} size={13} />
            <span style={{ fontSize: 12, color: C.grey }}>💼 {service.reviews} jobs completed</span>
          </div>
          <div style={{ borderTop: `1px solid ${C.border}`, marginTop: 12, paddingTop: 12 }}>
            <div style={{ fontWeight: 600, fontSize: 13, marginBottom: 6 }}>About this service</div>
            <div style={{ fontSize: 13, color: "#555", lineHeight: 1.6 }}>{service.description}</div>
          </div>
          <div style={{ borderTop: `1px solid ${C.border}`, marginTop: 12, paddingTop: 12, display: "flex", justifyContent: "space-between", alignItems: "center" }}>
            <span style={{ fontWeight: 600, fontSize: 13 }}>Rate</span>
            <span style={{ color: C.primary, fontWeight: 800, fontSize: 18 }}>{service.price}</span>
          </div>
        </div>

        {/* Portfolio */}
        <div style={{ background: C.white, border: `1px solid ${C.border}`, borderRadius: 12, padding: 16 }}>
          <div style={{ fontWeight: 700, fontSize: 14, marginBottom: 12 }}>Portfolio</div>
          <div style={{ display: "grid", gridTemplateColumns: "repeat(3, 1fr)", gap: 8 }}>
            {[...Array(6)].map((_, i) => (
              <div key={i} style={{ background: C.primary + "15", borderRadius: 8, aspectRatio: "1", display: "flex", alignItems: "center", justifyContent: "center", fontSize: 20 }}>
                {["🖼️","📸","🎨","✏️","🎬","📱"][i]}
              </div>
            ))}
          </div>
        </div>
      </div>

      <div style={{ padding: "12px 16px 24px", borderTop: `1px solid ${C.border}`, display: "flex", gap: 12 }}>
        <button onClick={() => onMessage(service.providerId, service.provider)} style={{ flex: 1, background: C.white, color: C.primary, border: `1px solid ${C.primary}`, borderRadius: 10, padding: "14px", fontWeight: 700, cursor: "pointer", fontSize: 13 }}>💬 Message</button>
        <button onClick={() => onMessage(service.providerId, service.provider)} style={{ flex: 1, background: C.primary, color: "#fff", border: "none", borderRadius: 10, padding: "14px", fontWeight: 700, cursor: "pointer", fontSize: 13 }}>🎓 Hire Student</button>
      </div>
    </div>
  );
}

// ── PRODUCT CARD ──────────────────────────────────────────
function ProductCard({ product, isFav, onFav, onTap, onAddToCart }) {
  return (
    <div onClick={onTap} style={{ background: C.white, borderRadius: 12, border: `1px solid ${C.border}`, cursor: "pointer", overflow: "hidden", display: "flex", flexDirection: "column" }}>
      <div style={{ position: "relative", background: C.lightGrey, height: 130, display: "flex", alignItems: "center", justifyContent: "center" }}>
        {product.imgPreviews?.[0] ? (
          <img src={product.imgPreviews[0]} alt="" style={{ width: "100%", height: "100%", objectFit: "cover" }} />
        ) : (
          <span style={{ fontSize: 48 }}>{product.emoji || "📦"}</span>
        )}
        {(product.isNew || product.isSale) && (
          <div style={{ position: "absolute", top: 6, left: 6, background: product.isNew ? C.green : C.primary, color: "#fff", borderRadius: 4, padding: "2px 6px", fontSize: 9, fontWeight: 700 }}>
            {product.isNew ? "NEW" : "SALE"}
          </div>
        )}
        <button onClick={e => { e.stopPropagation(); onFav(); }} style={{ position: "absolute", top: 6, right: 6, background: C.white, border: "none", borderRadius: "50%", width: 28, height: 28, cursor: "pointer", display: "flex", alignItems: "center", justifyContent: "center", fontSize: 14 }}>
          {isFav ? "❤️" : "🤍"}
        </button>
      </div>
      <div style={{ padding: "10px 10px 10px" }}>
        <div style={{ fontSize: 12, fontWeight: 600, color: C.dark, lineHeight: 1.3, marginBottom: 4, height: 30, overflow: "hidden" }}>{product.name}</div>
        {product.oldPrice && <div style={{ fontSize: 10, color: C.grey, textDecoration: "line-through" }}>{formatPrice(product.oldPrice)}</div>}
        <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginTop: 4 }}>
          <span style={{ fontSize: 13, fontWeight: 800, color: C.primary }}>{formatPrice(product.price)}</span>
          <button onClick={e => { e.stopPropagation(); onAddToCart(product); }} style={{ background: C.dark, color: "#fff", border: "none", borderRadius: 6, width: 24, height: 24, cursor: "pointer", display: "flex", alignItems: "center", justifyContent: "center", fontSize: 14 }}>+</button>
        </div>
        <div style={{ marginTop: 4 }}><StarRow rating={product.rating} /></div>
      </div>
    </div>
  );
}

// ── SERVICE CARD ─────────────────────────────────────────
function ServiceListCard({ service, isSaved, onSave, onTap }) {
  return (
    <div onClick={onTap} style={{ background: C.white, borderRadius: 12, border: `1px solid ${C.border}`, padding: 14, display: "flex", gap: 12, cursor: "pointer" }}>
      <div style={{ width: 56, height: 56, background: C.lightGrey, borderRadius: 12, display: "flex", alignItems: "center", justifyContent: "center", fontSize: 28, flexShrink: 0 }}>{service.emoji}</div>
      <div style={{ flex: 1, minWidth: 0 }}>
        <div style={{ display: "flex", justifyContent: "space-between", alignItems: "flex-start" }}>
          <div style={{ fontSize: 13, fontWeight: 700, color: C.dark, flex: 1, marginRight: 8 }}>{service.name}</div>
          <Badge label={service.category} />
        </div>
        <div style={{ fontSize: 11, color: C.grey, marginTop: 2, overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>{service.description}</div>
        <div style={{ display: "flex", gap: 6, alignItems: "center", marginTop: 6 }}>
          <span style={{ background: "#F0F0F0", color: C.grey, fontSize: 9, fontWeight: 600, padding: "2px 6px", borderRadius: 4 }}>{service.university}</span>
          <StarRow rating={service.rating} />
          <span style={{ fontSize: 10, color: C.grey }}>({service.reviews})</span>
        </div>
      </div>
      <div style={{ display: "flex", flexDirection: "column", alignItems: "flex-end", gap: 8, flexShrink: 0 }}>
        <button onClick={e => { e.stopPropagation(); onSave(); }} style={{ background: "none", border: "none", cursor: "pointer", fontSize: 18 }}>{isSaved ? "🔖" : "🏷️"}</button>
        <span style={{ fontSize: 12, fontWeight: 800, color: C.primary }}>{service.price}</span>
      </div>
    </div>
  );
}

// ── MAIN APP ─────────────────────────────────────────────
export default function MarketplaceApp() {
  const cart = useCart();
  const [products, setProducts] = useState(INITIAL_PRODUCTS);
  const [services, setServices] = useState(INITIAL_SERVICES);
  const [tab, setTab] = useState("Marketplace");
  const [productCat, setProductCat] = useState("All");
  const [serviceCat, setServiceCat] = useState("All");
  const [searchQ, setSearchQ] = useState("");
  const searchRef = useRef();
  const [favourites, setFavourites] = useState(new Set());
  const [savedServices, setSavedServices] = useState(new Set());

  // Panels
  const [showCart, setShowCart] = useState(false);
  const [showNotif, setShowNotif] = useState(false);
  const [showMsg, setShowMsg] = useState(false);
  const [showCreate, setShowCreate] = useState(false);
  const [detailItem, setDetailItem] = useState(null);
  const [detailService, setDetailService] = useState(null);
  const [notifications, setNotifications] = useState(NOTIFICATIONS);

  // Messaging state
  const [conversations, setConversations] = useState(() => {
    const convs = {};
    Object.entries(INITIAL_MESSAGES).forEach(([uid, msgs]) => {
      const seller = INITIAL_PRODUCTS.find(p => p.sellerId === uid) || INITIAL_SERVICES.find(s => s.providerId === uid);
      const name = seller?.seller || seller?.provider || "User";
      convs[uid] = { name, messages: msgs.map(m => ({ ...m, read: true })) };
    });
    return convs;
  });

  const openMessage = (uid, name) => {
    setConversations(prev => ({
      ...prev,
      [uid]: prev[uid] || { name, messages: [] }
    }));
    setShowMsg(true);
    setDetailItem(null);
    setDetailService(null);
  };

  const sendMessage = (uid, text) => {
    const now = new Date();
    const time = now.toLocaleTimeString("en-ZA", { hour: "2-digit", minute: "2-digit" });
    const myMsg = { from: "me", text, time, read: true };
    setConversations(prev => ({
      ...prev,
      [uid]: { ...prev[uid], messages: [...(prev[uid]?.messages || []), myMsg] }
    }));
    // Simulate reply after 1.5s
    setTimeout(() => {
      const replies = ["Thanks! When would you like to meet?", "Sure, I can help with that!", "Great! Let me know your availability.", "I'll get back to you shortly.", "Sounds good! Send me more details."];
      const reply = { from: uid, text: replies[Math.floor(Math.random() * replies.length)], time: new Date().toLocaleTimeString("en-ZA", { hour: "2-digit", minute: "2-digit" }), read: false };
      setConversations(prev => ({
        ...prev,
        [uid]: { ...prev[uid], messages: [...(prev[uid]?.messages || []), reply] }
      }));
      setNotifications(prev => [{ id: Date.now(), text: `${prev.find(n => n.id === uid)?.text || (conversations[uid]?.name || "Someone")} replied to your message`, time: "just now", read: false }, ...prev]);
    }, 1500);
  };

  const unreadMsgCount = Object.values(conversations).reduce((sum, c) => sum + c.messages.filter(m => m.from !== "me" && !m.read).length, 0);
  const unreadNotifCount = notifications.filter(n => !n.read).length;

  const filteredProducts = products.filter(p => {
    const cat = productCat === "All" || p.category === productCat;
    const q = !searchQ || p.name.toLowerCase().includes(searchQ.toLowerCase()) || p.category.toLowerCase().includes(searchQ.toLowerCase());
    return cat && q;
  });

  const filteredServices = services.filter(s => {
    const cat = serviceCat === "All" || s.category === serviceCat;
    const q = !searchQ || s.name.toLowerCase().includes(searchQ.toLowerCase()) || s.description.toLowerCase().includes(searchQ.toLowerCase());
    return cat && q;
  });

  const handleNewPost = (data) => {
    if (data.type === "product") {
      const newP = {
        id: "u" + Date.now(),
        name: data.title,
        brand: "My Listing",
        price: parseFloat(data.price) || 0,
        oldPrice: null,
        rating: 5.0,
        reviews: 0,
        emoji: "📦",
        category: data.category,
        description: data.description,
        isNew: true,
        isSale: false,
        seller: "You",
        sellerId: "me",
        university: "My University",
        imgPreviews: data.imgPreviews || [],
        condition: data.condition,
      };
      setProducts(prev => [newP, ...prev]);
    } else {
      const newS = {
        id: "s" + Date.now(),
        name: data.name,
        description: data.description,
        price: data.price,
        emoji: "⭐",
        category: data.category,
        provider: "You",
        providerId: "me",
        university: "My University",
        rating: 5.0,
        reviews: 0,
        isFeatured: false,
      };
      setServices(prev => [newS, ...prev]);
    }
  };

  // If showing detail pages
  if (detailItem) return (
    <div style={{ fontFamily: "-apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif", maxWidth: 480, margin: "0 auto" }}>
      <ProductDetail item={detailItem} onBack={() => setDetailItem(null)} onAddToCart={p => { cart.add(p); }} onMessage={openMessage} />
      {showCart && <CartPanel cart={cart} onClose={() => setShowCart(false)} />}
      {showMsg && <MessagingPanel conversations={conversations} onSend={sendMessage} onClose={() => setShowMsg(false)} />}
    </div>
  );

  if (detailService) return (
    <div style={{ fontFamily: "-apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif", maxWidth: 480, margin: "0 auto" }}>
      <ServiceDetail service={detailService} onBack={() => setDetailService(null)} onMessage={openMessage} />
      {showMsg && <MessagingPanel conversations={conversations} onSend={sendMessage} onClose={() => setShowMsg(false)} />}
    </div>
  );

  return (
    <div style={{ fontFamily: "-apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif", maxWidth: 480, margin: "0 auto", background: C.white, minHeight: "100vh", display: "flex", flexDirection: "column" }}>
      {/* ── TOP BAR ── */}
      <div style={{ padding: "12px 12px", borderBottom: `1px solid ${C.border}`, background: C.white, position: "sticky", top: 0, zIndex: 50 }}>
        <div style={{ display: "flex", alignItems: "center", gap: 8 }}>
          <span style={{ fontWeight: 800, fontSize: 17, color: C.dark, flexShrink: 0 }}>Marketplace</span>
          {/* Search */}
          <div style={{ flex: 1, background: C.lightGrey, border: `1px solid ${C.border}`, borderRadius: 8, display: "flex", alignItems: "center", overflow: "hidden" }}>
            <input
              ref={searchRef}
              value={searchQ}
              onChange={e => setSearchQ(e.target.value)}
              placeholder="Search…"
              style={{ flex: 1, background: "none", border: "none", outline: "none", padding: "9px 10px", fontSize: 13, color: C.dark }}
            />
            {searchQ && <button onClick={() => setSearchQ("")} style={{ background: "none", border: "none", color: C.grey, cursor: "pointer", padding: "0 6px", fontSize: 13 }}>✕</button>}
            <div style={{ background: C.primary, width: 36, height: 36, display: "flex", alignItems: "center", justifyContent: "center", flexShrink: 0 }}>
              <span style={{ color: "#fff", fontSize: 14 }}>🔍</span>
            </div>
          </div>

          {/* Icon buttons */}
          <div style={{ display: "flex", gap: 4, alignItems: "center" }}>
            {/* Notifications */}
            <button onClick={() => { setShowNotif(p => !p); setShowCart(false); setShowMsg(false); }} style={{ position: "relative", background: C.lightGrey, border: `1px solid ${C.border}`, borderRadius: 8, width: 32, height: 32, cursor: "pointer", display: "flex", alignItems: "center", justifyContent: "center" }}>
              <span style={{ fontSize: 14 }}>🔔</span>
              {unreadNotifCount > 0 && <div style={{ position: "absolute", top: -3, right: -3, background: C.primary, color: "#fff", borderRadius: "50%", width: 14, height: 14, fontSize: 8, fontWeight: 700, display: "flex", alignItems: "center", justifyContent: "center" }}>{unreadNotifCount}</div>}
            </button>

            {/* Messages */}
            <button onClick={() => { setShowMsg(true); setShowNotif(false); setShowCart(false); }} style={{ position: "relative", background: C.lightGrey, border: `1px solid ${C.border}`, borderRadius: 8, width: 32, height: 32, cursor: "pointer", display: "flex", alignItems: "center", justifyContent: "center" }}>
              <span style={{ fontSize: 14 }}>💬</span>
              {unreadMsgCount > 0 && <div style={{ position: "absolute", top: -3, right: -3, background: C.primary, color: "#fff", borderRadius: "50%", width: 14, height: 14, fontSize: 8, fontWeight: 700, display: "flex", alignItems: "center", justifyContent: "center" }}>{unreadMsgCount}</div>}
            </button>

            {/* Cart */}
            <button onClick={() => { setShowCart(true); setShowNotif(false); setShowMsg(false); }} style={{ position: "relative", background: C.lightGrey, border: `1px solid ${C.border}`, borderRadius: 8, width: 32, height: 32, cursor: "pointer", display: "flex", alignItems: "center", justifyContent: "center" }}>
              <span style={{ fontSize: 14 }}>🛒</span>
              {cart.count > 0 && <div style={{ position: "absolute", top: -3, right: -3, background: C.primary, color: "#fff", borderRadius: "50%", width: 14, height: 14, fontSize: 8, fontWeight: 700, display: "flex", alignItems: "center", justifyContent: "center" }}>{cart.count}</div>}
            </button>

            {/* Profile */}
            <div style={{ width: 32, height: 32, borderRadius: "50%", background: C.primary, display: "flex", alignItems: "center", justifyContent: "center", cursor: "pointer" }}>
              <span style={{ color: "#fff", fontWeight: 700, fontSize: 13 }}>S</span>
            </div>
          </div>
        </div>
      </div>

      {/* ── TAB ROW ── */}
      <div style={{ display: "flex", alignItems: "center", padding: "0 12px", borderBottom: `1px solid ${C.border}`, gap: 8 }}>
        {["Marketplace", "Services"].map(t => (
          <button key={t} onClick={() => { setTab(t); setSearchQ(""); }} style={{ padding: "10px 14px", background: tab === t ? C.primary : "transparent", borderRadius: 6, border: "none", color: tab === t ? "#fff" : C.grey, fontWeight: 600, fontSize: 13, cursor: "pointer" }}>{t}</button>
        ))}
        <div style={{ flex: 1 }} />
        {/* Create Post */}
        <button onClick={() => setShowCreate(true)} style={{ background: C.dark, color: "#fff", border: "none", borderRadius: 8, padding: "7px 12px", fontSize: 12, fontWeight: 600, cursor: "pointer", display: "flex", alignItems: "center", gap: 4 }}>
          <span>+</span> Post
        </button>
        <select style={{ border: `1px solid ${C.border}`, borderRadius: 6, padding: "6px 8px", fontSize: 11, color: C.dark, outline: "none" }}>
          {["Most popular", "Price: Low to High", "Price: High to Low", "Newest", "Rating"].map(o => <option key={o}>{o}</option>)}
        </select>
      </div>

      {/* ── SCROLLABLE BODY ── */}
      <div style={{ flex: 1, overflowY: "auto" }}>
        {tab === "Marketplace" ? (
          <div>
            {/* Banner */}
            {!searchQ && (
              <div style={{ margin: 16, background: "linear-gradient(135deg, #1A1A1A 0%, #333 100%)", borderRadius: 14, padding: "20px 20px", display: "flex", alignItems: "center", justifyContent: "space-between", height: 130 }}>
                <div>
                  <div style={{ background: C.primary, color: "#fff", fontSize: 9, fontWeight: 800, padding: "3px 8px", borderRadius: 4, display: "inline-block", marginBottom: 8 }}>BLACK FRIDAY</div>
                  <div style={{ color: "#fff", fontSize: 20, fontWeight: 900, lineHeight: 1.2 }}>40% Off<br />Everything</div>
                  <div style={{ color: "rgba(255,255,255,0.6)", fontSize: 11, marginTop: 4 }}>From R6,000 – R9,294.99</div>
                </div>
                <span style={{ fontSize: 64 }}>📺</span>
              </div>
            )}

            {searchQ && <div style={{ padding: "12px 16px 0", color: C.grey, fontSize: 13, fontStyle: "italic" }}>Results for "{searchQ}"</div>}

            {/* Categories */}
            <div style={{ padding: "14px 16px 0" }}>
              <div style={{ fontWeight: 700, fontSize: 14, color: C.dark, marginBottom: 10 }}>Categories</div>
              <div style={{ display: "flex", gap: 8, overflowX: "auto", paddingBottom: 4 }}>
                {PRODUCT_CATEGORIES.map(cat => (
                  <button key={cat} onClick={() => setProductCat(cat)} style={{ padding: "7px 14px", background: productCat === cat ? C.primary : C.lightGrey, color: productCat === cat ? "#fff" : C.grey, borderRadius: 6, border: "none", fontSize: 12, fontWeight: 600, cursor: "pointer", flexShrink: 0 }}>{cat}</button>
                ))}
              </div>
            </div>

            {/* Products header */}
            <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", padding: "14px 16px 8px" }}>
              <span style={{ fontWeight: 700, fontSize: 14, color: C.dark }}>{filteredProducts.length} Products</span>
              <span style={{ fontSize: 12, color: C.primary, fontWeight: 500 }}>View all</span>
            </div>

            {/* Product Grid */}
            <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 12, padding: "0 16px 16px" }}>
              {filteredProducts.map(p => (
                <ProductCard
                  key={p.id}
                  product={p}
                  isFav={favourites.has(p.id)}
                  onFav={() => setFavourites(prev => { const n = new Set(prev); n.has(p.id) ? n.delete(p.id) : n.add(p.id); return n; })}
                  onTap={() => setDetailItem(p)}
                  onAddToCart={product => cart.add(product)}
                />
              ))}
            </div>

            {filteredProducts.length === 0 && (
              <div style={{ textAlign: "center", padding: 40, color: C.grey }}>
                <div style={{ fontSize: 40, marginBottom: 8 }}>🔍</div>
                <div>No products found</div>
              </div>
            )}
          </div>
        ) : (
          /* SERVICES TAB */
          <div>
            {/* Services hero */}
            {!searchQ && (
              <div style={{ margin: 16, background: "linear-gradient(135deg, #1A1A1A, #2D2D2D)", borderRadius: 14, padding: 16, display: "flex", alignItems: "center" }}>
                <div style={{ flex: 1 }}>
                  <div style={{ background: C.primary, color: "#fff", fontSize: 9, fontWeight: 800, padding: "3px 8px", borderRadius: 4, display: "inline-block", marginBottom: 8 }}>STUDENT SERVICES</div>
                  <div style={{ color: "#fff", fontSize: 18, fontWeight: 900, lineHeight: 1.2 }}>Skills for hire,<br />right on campus</div>
                  <div style={{ color: "rgba(255,255,255,0.6)", fontSize: 11, marginTop: 4 }}>{services.length} services available now</div>
                </div>
                <span style={{ fontSize: 56 }}>🎓</span>
              </div>
            )}

            {searchQ && <div style={{ padding: "12px 16px 0", color: C.grey, fontSize: 13, fontStyle: "italic" }}>Results for "{searchQ}"</div>}

            {/* Service Categories */}
            <div style={{ display: "flex", gap: 8, overflowX: "auto", padding: "0 16px 0", paddingBottom: 4 }}>
              {SERVICE_CATEGORIES.map(cat => (
                <button key={cat} onClick={() => setServiceCat(cat)} style={{ padding: "7px 14px", background: serviceCat === cat ? C.primary : C.lightGrey, color: serviceCat === cat ? "#fff" : C.grey, borderRadius: 6, border: "none", fontSize: 12, fontWeight: 600, cursor: "pointer", flexShrink: 0 }}>{cat}</button>
              ))}
            </div>

            {/* Featured */}
            {!searchQ && serviceCat === "All" && (
              <>
                <div style={{ fontWeight: 700, fontSize: 14, color: C.dark, padding: "14px 16px 8px" }}>⭐ Featured Services</div>
                <div style={{ display: "flex", gap: 12, overflowX: "auto", padding: "0 16px 8px" }}>
                  {services.filter(s => s.isFeatured).map(s => (
                    <div key={s.id} onClick={() => setDetailService(s)} style={{ width: 190, flexShrink: 0, background: C.white, border: `1px solid ${C.border}`, borderRadius: 12, cursor: "pointer", overflow: "hidden" }}>
                      <div style={{ background: C.lightGrey, height: 90, display: "flex", alignItems: "center", justifyContent: "center", position: "relative" }}>
                        <span style={{ fontSize: 40 }}>{s.emoji}</span>
                        <div style={{ position: "absolute", top: 6, left: 6 }}><Badge label={s.category} /></div>
                      </div>
                      <div style={{ padding: 10 }}>
                        <div style={{ fontWeight: 700, fontSize: 12, color: C.dark, marginBottom: 2, overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>{s.name}</div>
                        <div style={{ fontSize: 10, color: C.grey }}>{s.provider}</div>
                        <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginTop: 6 }}>
                          <span style={{ fontSize: 13, fontWeight: 800, color: C.primary }}>{s.price}</span>
                          <StarRow rating={s.rating} />
                        </div>
                      </div>
                    </div>
                  ))}
                </div>
              </>
            )}

            {/* All services list */}
            <div style={{ padding: "8px 16px 8px" }}>
              <span style={{ fontWeight: 700, fontSize: 14, color: C.dark }}>
                {searchQ ? `${filteredServices.length} results` : serviceCat === "All" ? `All Services (${filteredServices.length})` : `${serviceCat} (${filteredServices.length})`}
              </span>
            </div>
            <div style={{ display: "flex", flexDirection: "column", gap: 12, padding: "0 16px 40px" }}>
              {filteredServices.map(s => (
                <ServiceListCard
                  key={s.id}
                  service={s}
                  isSaved={savedServices.has(s.id)}
                  onSave={() => setSavedServices(prev => { const n = new Set(prev); n.has(s.id) ? n.delete(s.id) : n.add(s.id); return n; })}
                  onTap={() => setDetailService(s)}
                />
              ))}
              {filteredServices.length === 0 && (
                <div style={{ textAlign: "center", padding: 40, color: C.grey }}>
                  <div style={{ fontSize: 40, marginBottom: 8 }}>🔍</div>
                  <div>No services found</div>
                </div>
              )}
            </div>
          </div>
        )}
      </div>

      {/* ── MODALS ── */}
      {showCart && <CartPanel cart={cart} onClose={() => setShowCart(false)} />}
      {showNotif && (
        <NotificationsPanel
          notifications={notifications}
          onClose={() => setShowNotif(false)}
          onMarkAll={() => setNotifications(prev => prev.map(n => ({ ...n, read: true })))}
        />
      )}
      {showMsg && <MessagingPanel conversations={conversations} onSend={sendMessage} onClose={() => setShowMsg(false)} />}
      {showCreate && <CreatePostModal onClose={() => setShowCreate(false)} onSubmit={handleNewPost} />}
    </div>
  );
}
