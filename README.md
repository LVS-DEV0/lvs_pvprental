# 🚗 LVS PVP Rent Car

A professional, high-performance, and multi-framework car rental script for FiveM. Designed for PVP and competitive servers with a sleek NUI and ultra-optimized code.

## ✨ Features

- 🏎️ **Modern NUI:** Premium design with glassmorphism and smooth animations.
- 🌐 **Multi-Language Support:** Supports 10 languages (EN, TR, DE, FR, ES, IT, PT, RU, PL, NL) out of the box.
- 🏗️ **Framework Bridge:** Compatible with Qbox, QB-Core, and ESX.
- 💎 **VIP System:** Dedicated currency support (lcoin) for exclusive vehicles.
- ⚡ **Ultra Optimized:** 0.00ms resmon on idle, built for 200+ player environments.
- 🔑 **Key Support:** Integrated with `qbx_vehiclekeys`, `qb-vehiclekeys`, and `wasabi_carkeys`.
- 🗑️ **Auto Cleanup:** Vehicles are automatically deleted when the player disconnects.

## 🛠️ Installation

1. Download the script and place it in your `resources` folder.
2. Ensure you have `ox_lib` installed.
3. Update `config.lua` to match your server's needs.
4. Add `ensure lvs_pvprentcar` to your `server.cfg`.

## 💰 VIP Currency Setup (lcoin)

You must add the custom currency (account) to your framework for the shop to function correctly if you use VIP vehicles.

### **Qbox / QB-Core**
Edit `qb-core/config.lua` or `qbx_core/config/server.lua`:

```lua
-- Add 'lcoin' to MoneyTypes and DontAllowMinus
MoneyTypes = { cash = 500, bank = 5000, crypto = 0, lcoin = 0 },
DontAllowMinus = { 'cash', 'crypto', 'lcoin' }
```

### **ESX (es_extended)**
Edit `es_extended/shared/config/main.lua`:

```lua
Config.Accounts = {
    -- ... existing accounts
    lcoin = {
        label = 'L-Coin',
        round = true,
    },
}
```

## 🌍 Locales

The script uses `ox_lib` locale system. To change the language, edit your `fxmanifest.lua` or set the global locale in `ox_lib`:

```lua
-- In fxmanifest.lua
ox_libs {
    'locale'
}
```

Available languages in `/locales` folder.

## 📞 Support & Credits

Developed by **lvs-development**.
Join our community for updates and support.
