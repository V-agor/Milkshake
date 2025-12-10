Write-Host "🚀 Creating Milkshake Frontend..."

# Ensure we are inside milkshake_frontend
Set-Location "C:\Users\27810\Desktop\Milkshake_app\milkshake_frontend"

# 1) Create React App
Write-Host "📦 Installing React..."
npx create-react-app . --use-npm

# 2) Install dependencies
Write-Host "📚 Installing axios + react-router..."
npm install axios react-router-dom

# 3) Remove CRA default src
Write-Host "🧹 Removing default CRA src..."
Remove-Item -Recurse -Force "src"

# 4) Rebuild src folders
Write-Host "📁 Rebuilding src structure..."
New-Item -ItemType Directory -Force -Path "src" | Out-Null
New-Item -ItemType Directory -Force -Path "src\api" | Out-Null
New-Item -ItemType Directory -Force -Path "src\components" | Out-Null
New-Item -ItemType Directory -Force -Path "src\pages" | Out-Null

# 5) Create styles.css
@"
body { font-family: Arial; margin:0; padding:0; }
.container { padding:20px; max-width:1000px; margin:0 auto; }
.header { display:flex; justify-content:space-between; align-items:center; margin-bottom:20px; }
.button { padding:8px 12px; cursor:pointer; background:#2b7cff; color:white; border:none; border-radius:4px; }
.input { padding:8px; width:100%; margin:6px 0; }
"@ | Out-File "src\styles.css"

# 6) Create index.js
@"
import React from "react";
import { createRoot } from "react-dom/client";
import App from "./App";
import "./styles.css";

const root = createRoot(document.getElementById("root"));
root.render(<App />);
"@ | Out-File "src\index.js"

# 7) Create App.js
@"
import React from "react";
import { BrowserRouter, Routes, Route, Navigate } from "react-router-dom";
import Signup from "./pages/Signup";
import Login from "./pages/Login";
import OrderBuilder from "./pages/OrderBuilder";
import Checkout from "./pages/Checkout";
import Success from "./pages/Success";
import OrderHistory from "./pages/OrderHistory";

function RequireAuth({ children }) {
  const token = localStorage.getItem("token");
  return token ? children : <Navigate to="/login" />;
}

export default function App(){
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<OrderBuilder />} />
        <Route path="/signup" element={<Signup />} />
        <Route path="/login" element={<Login />} />
        <Route path="/checkout" element={<RequireAuth><Checkout /></RequireAuth>} />
        <Route path="/success" element={<Success />} />
        <Route path="/orders" element={<RequireAuth><OrderHistory /></RequireAuth>} />
      </Routes>
    </BrowserRouter>
  );
}
"@ | Out-File "src\App.js"

Write-Host "✨ Frontend base created! You now need pages."
