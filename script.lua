-- Hanzz_TSC Script
-- Template by Chardox Core
MEMORY_RANGE = nil
MEMORY_NAME = nil
USER_NAME = nil

-- ==========================================
-- KONFIGURASI FILE & URL PASTEBIN
-- ==========================================
local nameFile = "/sdcard/Hanzz_User.txt"
local keyFile = "/sdcard/Hanzz_Key.txt"
local RAW_PASTEBIN_URL = "https://pastebin.com/raw/REnycS4A"

-- Pindahin deklarasi variabel global ke ATAS biar ga nil
local backupSkills = {}
local editHistory = {}
local favoriteSkills = {}

local favFile = "/sdcard/Notes/Hanzz_Favorite.txt"

-- Fungsi muat favorit dari file
local function loadFavorite()
    favoriteSkills = {}
    local file = io.open(favFile, "r")
    if file then
        for line in file:lines() do
            local clean = line:match("^%s*(.-)%s*$")
            if clean ~= "" then
                table.insert(favoriteSkills, clean)
            end
        end
        file:close()
    end
end

-- Fungsi simpan favorit ke file
local function saveFavorite()
    -- HAPUS os.execute("mkdir -p ...") KARENA DI-BLOCK GG
    local file = io.open(favFile, "w")
    if file then
        for _, skill in ipairs(favoriteSkills) do
            file:write(skill .. "\n")
        end
        file:close()
    else
        gg.toast("❌ Gagal nyimpen file favorit! Pastikan folder /sdcard/Notes/ ada.")
    end
end

-- ==========================================
-- DATABASE LIST SKILL (GLOBAL)
-- ==========================================
local allNormalSkills = {
    "AbsoluteBlock", "AbyssToss_SkinStarOfTheEncore", "AlwaysGotoBlock", "AlwaysNoon", "AlwaysParry",
    "AssistModeBallPause", "AutoCorrectSpike", "BeastFang", "BeastSpike", "BeastSpikeForAI",
    "BladeWind", "BlinkBallHighSchool", "BlinkBall_BlackThunder", "BlinkBall_Rainbow", "BlitzSpin",
    "BlueDragon", "BlueDragon_SkinDosa", "BlueDragon_SkinRedhood", "BraveHeart", "BraveTiger",
    "BraveTiger_SkinMaid", "BungeoPpang", "CalmBeforeTheStorm", "CancelBlockOnOut", "CannotSlide",
    "CemeteryGates", "Charge", "Charge_Jenny", "Charge_Jenny_SkinShootingStar", "ChemicalHit",
    "ChemicalHit_SkinAhyeonStein", "CoreHit", "CourtCompass", "CowardJacobHorror",
    "CriticalToss_SkinWaterSplash", "CrownPass", "DarkCrow", "DeathFlower_SkinMidnight",
    "DeepSpike", "DeepSpikeInsteadFeint", "Determination", "Determination_Training",
    "DirectSpiker", "DirectToss", "DoubleSpike", "DoubleSpike_SkinBlack", "DreamEater",
    "EasyAttackForBeginnerToss", "EveryActionSpike", "ExcellentConcentration", "FarPassFeint",
    "FastBlockCharge", "FastNoon", "FeintNearTheNet", "FeintWhenNotToss", "FeintWhenOpponentHPLow",
    "FeintWhenWinning", "Flare", "Flare_SkinSummerTraining", "FlowerReceive", "FlyingGuard",
    "FocusOnQuickWhenWinning", "ForceSpikeAimCenter", "FortuneTurn", "Frantic", "GearUp",
    "GearUp_SkinHomunculus", "GetWeaker", "GitaeFirstBlock", "Gitae_AI", "GladiusWall",
    "GladiusWall_SkinBountyHunter", "GuardStrike", "Gust", "HeadToHead", "HealingToss",
    "HealingToss_SkinSummerTraining", "Helios", "Helios_SkinSummerTraining", "HiddenBrilliance",
    "HighThirdReceive", "HighVerticalServeToss", "HighVerticalServeToss_BlackThunder",
    "Highlight", "HundredForgedSteel", "HybridFloaterServe", "HybridFloaterServe_SkinStarOfTheEncore",
    "Icarus", "Icarus_SkinShootingStar", "Icarus_SkinStrawHat", "ImperialOrder", "Intimidation",
    "Intimidation_2", "IronClaw", "IronHalberd", "IsabelHomunculusLastSpike", "KindDictator",
    "LightOfHope", "LightStepMB", "Lock", "LongSpike", "LongSpikeToBlockOut", "LongSpikeToLine",
    "LongWaitSpike", "LucasServeToss", "LunarFlask", "Meow", "MetalBlood", "MiddleVerticalServeToss",
    "MiraculousToss", "Noon", "Noon_Des", "Noon_SunSetDes", "OasisServeToss", "OffensiveDirectToss",
    "OnepointPlayer", "OutOfBoundsSpike", "OutOfShape", "Overdrive", "Overdrive_SkinGodFather",
    "Parry_SkinHomunculus", "Parry_SkinWedding", "RaulFirstImpact", "RedHoodRyuhyunFirstImpact",
    "RyuhyunRedhoodFurstImpact", "SkyServeLisia_SkinRudolph", "ThunderSpike_HighSchool",
    "ThunderSpike_Original", "ThunderSpike_SkinBlack", "VerticalSpike", "VerticalSpikeJenny",
    "WhiteSpike", "Default"
}

local allNormalHex = {
    "41 62 73 6F 6C 75 74 65 42 6C 6F 63 6B 00", "41 62 79 73 73 54 6F 73 73 5F 53 6B 69 6E 53 74 61 72 4F 66 54 68 65 45 6E 63 6F 72 65 00",
    "41 6C 77 61 79 73 47 6F 74 6F 42 6C 6F 63 6B 00", "41 6C 77 61 79 73 4E 6F 6F 6E 00", "50 61 72 72 79 5F 41 6C 77 61 79 73 50 61 72 72 79 00",
    "41 73 73 69 73 74 4D 6F 64 65 42 61 6C 6C 50 61 75 73 65 00", "41 75 74 6F 43 6F 72 72 65 63 74 53 70 69 6B 65 00",
    "42 65 61 73 74 46 61 6E 67 00", "42 65 61 73 74 53 70 69 6B 65 00", "42 65 61 73 74 53 70 69 6B 65 46 6F 72 41 49 00",
    "42 6C 61 64 65 57 69 6E 64 00", "42 6C 69 6E 6B 42 61 6C 6C 5F 54 68 75 6E 64 65 72 5F 48 69 67 68 73 63 68 6F 6F 6C 00",
    "42 6C 69 6E 6B 42 61 6C 6C 5F 42 6C 61 63 6B 54 68 75 6E 64 65 72 00", "42 6C 69 6E 6B 42 61 6C 6C 5F 52 61 69 6E 62 6F 77 00",
    "42 6C 69 74 7A 53 70 69 6E 00", "42 6C 75 65 44 72 61 67 6F 6E 00", "42 6C 75 65 44 72 61 67 6F 6E 5F 53 6B 69 6E 44 6F 73 61 00",
    "42 6C 75 65 44 72 61 67 6F 6E 5F 53 6B 69 6E 52 65 64 48 6F 6F 64 00", "42 72 61 76 65 48 65 61 72 74 00", "42 72 61 76 65 54 69 67 65 72 00",
    "42 72 61 76 65 54 69 67 65 72 5F 53 6B 69 6E 4D 61 69 64 00", "42 75 6E 67 65 6F 50 70 61 6E 67 00", "43 61 6C 6D 42 65 66 6F 72 65 54 68 65 53 74 6F 72 6D 00",
    "43 61 6E 63 65 6C 42 6C 6F 63 6B 4F 6E 4F 75 74 00", "43 61 6E 6E 6F 74 53 6C 69 64 65 00", "43 65 6D 65 74 65 72 79 47 61 74 65 73 00",
    "43 68 61 72 67 65 00", "43 68 61 72 67 65 5F 4A 65 6E 6E 79 00", "43 68 61 72 67 65 5F 4A 65 6E 6E 79 5F 53 6B 69 6E 53 68 6F 6F 74 69 6E 67 53 74 61 72 00",
    "43 68 65 6D 69 63 61 6C 48 69 74 00", "43 68 65 6D 69 63 61 6C 48 69 74 5F 53 6B 69 6E 41 68 79 65 6F 6E 53 74 65 69 6E 00",
    "43 6F 72 65 48 69 74 00", "43 6F 75 72 74 43 6F 6D 70 61 73 73 00", "43 6F 77 61 72 64 4A 61 63 6F 62 48 6F 72 72 6F 72 00",
    "43 72 69 74 69 63 61 6C 54 6F 73 73 5F 53 6B 69 6E 57 61 74 65 72 53 70 6C 61 73 68 00", "43 72 6F 77 6E 50 61 73 73 00",
    "44 61 72 6B 43 72 6F 77 00", "44 65 61 74 68 46 6C 6F 77 65 72 5F 53 6B 69 6E 4D 69 64 6E 69 67 68 74 00",
    "44 65 65 70 53 70 69 6B 65 00", "44 65 65 70 53 70 69 6B 65 49 6E 73 74 65 61 64 46 65 69 6E 74 00",
    "44 65 74 65 72 6D 69 6E 61 74 69 6F 6E 00", "44 65 74 65 72 6D 69 6E 61 74 69 6F 6E 5F 54 72 61 69 6E 69 6E 67 00",
    "44 69 72 65 63 74 53 70 69 6B 65 72 00", "44 69 72 65 63 74 54 6F 73 73 00", "44 6F 75 62 6C 65 53 70 69 6B 65 00",
    "44 6F 75 62 6C 65 53 70 69 6B 65 5F 53 6B 69 6E 42 6C 61 63 6B 00", "44 72 65 61 6D 45 61 74 65 72 00",
    "45 61 73 79 41 74 74 61 63 6B 46 6F 72 42 65 67 69 6E 6E 65 72 54 6F 73 73 00", "45 76 65 72 79 41 63 74 69 6F 6E 53 70 69 6B 65 00",
    "45 78 63 65 6C 6C 65 6E 74 43 6F 6E 63 65 6E 74 72 61 74 69 6F 6E 00", "46 61 72 50 61 73 73 46 65 69 6E 74 00",
    "46 61 73 74 42 6C 6F 63 6B 43 68 61 72 67 65 00", "46 61 73 74 4E 6F 6F 6E 00", "46 65 69 6E 74 4E 65 61 72 54 68 65 4E 65 74 00",
    "46 65 69 6E 74 57 68 65 6E 4E 6F 74 54 6F 73 73 00", "46 65 69 6E 74 57 68 65 6E 4F 70 70 6F 6E 65 6E 74 48 50 4C 6F 77 00",
    "46 65 69 6E 74 57 68 65 6E 57 69 6E 6E 69 6E 67 00", "46 6C 61 72 65 00", "46 6C 61 72 65 5F 53 6B 69 6E 53 75 6D 6D 65 72 54 72 61 69 6E 69 6E 67 00",
    "46 6C 6F 77 65 72 52 65 63 65 69 76 65 00", "46 6C 79 69 6E 67 47 75 61 72 64 00", "46 6F 63 75 73 4F 6E 51 75 69 63 6B 57 68 65 6E 57 69 6E 6E 69 6E 67 00",
    "46 6F 72 63 65 53 70 69 6B 65 41 69 6D 43 65 6E 74 65 72 00", "46 6F 72 74 75 6E 65 73 54 75 72 6E 00", "46 72 61 6E 74 69 63 00",
    "47 65 61 72 55 70 00", "47 65 61 72 55 70 5F 53 6B 69 6E 48 6F 6D 75 6E 63 75 6C 75 73 00", "47 65 74 57 65 61 6B 65 72 00",
    "47 69 74 61 65 46 69 72 73 74 42 6C 6F 63 6B 00", "47 69 74 61 65 5F 41 49 00", "47 6C 61 64 69 75 73 57 61 6C 6C 00",
    "47 6C 61 64 69 75 73 57 61 6C 6C 5F 53 6B 69 6E 42 6F 75 6E 74 79 48 75 6E 74 65 72 00", "47 75 61 72 64 53 74 72 69 6B 65 00", "47 75 73 74 00",
    "48 65 61 64 54 6F 48 65 61 64 00", "48 65 61 6C 69 6E 67 54 6F 73 73 00", "48 65 61 6C 69 6E 67 54 6F 73 73 5F 53 6B 69 6E 53 75 6D 6D 65 72 54 72 61 69 6E 69 6E 67 00",
    "48 65 6C 69 6F 73 00", "48 65 6C 69 6F 73 5F 53 6B 69 6E 53 75 6D 6D 65 72 54 72 61 69 6E 69 6E 67 00", "48 69 64 64 65 6E 42 72 69 6C 6C 69 61 6E 63 65 00",
    "48 69 67 68 54 68 69 72 64 52 65 63 65 69 76 65 00", "48 69 67 68 56 65 72 74 69 63 61 6C 53 65 72 76 65 54 6F 73 73 00",
    "48 69 67 68 56 65 72 74 69 63 61 6C 53 65 72 76 65 54 6F 73 73 5F 42 6C 61 63 6B 54 68 75 6E 64 65 72 00",
    "48 69 67 68 6C 69 67 68 74 00", "48 75 6E 64 72 65 64 46 6F 72 67 65 64 53 74 65 65 6C 00",
    "48 79 62 72 69 64 46 6C 6F 61 74 65 72 53 65 72 76 65 00", "48 79 62 72 69 64 46 6C 6F 61 74 65 72 53 65 72 76 65 5F 53 6B 69 6E 53 74 61 72 4F 66 54 68 65 45 6E 63 6F 72 65 00",
    "49 63 61 72 75 73 00", "49 63 61 72 75 73 5F 53 6B 69 6E 53 68 6F 6F 74 69 6E 67 53 74 61 72 00", "49 63 61 72 75 73 5F 53 6B 69 6E 53 74 72 61 77 48 61 74 00",
    "49 6D 70 65 72 69 61 6C 4F 72 64 65 72 00", "49 6E 74 69 6D 69 64 61 74 69 6F 6E 00", "49 6E 74 69 6D 69 64 61 74 69 6F 6E 5F 32 00",
    "49 72 6F 6E 43 6C 61 77 00", "49 72 6F 6E 48 61 6C 62 65 72 64 00", "49 73 61 62 65 6C 48 6F 6D 75 6E 63 75 6C 75 73 4C 61 73 74 53 70 69 6B 65 00",
    "4B 69 6E 64 44 69 63 74 61 74 6F 72 00", "4C 69 67 68 74 4F 66 48 6F 70 65 00", "4C 69 67 68 74 53 74 65 70 4D 42 00",
    "4C 6F 63 6B 00", "4C 6F 6E 67 53 70 69 6B 65 00", "4C 6F 6E 67 53 70 69 6B 65 54 6F 42 6C 6F 63 6B 4F 75 74 00",
    "4C 6F 6E 67 53 70 69 6B 65 54 6F 4C 69 6E 65 00", "4C 6F 6E 67 57 61 69 74 53 70 69 6B 65 00", "4C 75 63 61 73 53 65 72 76 65 54 6F 73 73 00",
    "4C 75 6E 61 72 46 6C 61 73 6B 00", "4D 65 6F 77 00", "4D 65 74 61 6C 42 6C 6F 6F 64 00",
    "4D 69 64 64 6C 65 56 65 72 74 69 63 61 6C 53 65 72 76 65 54 6F 73 73 00", "4D 69 72 61 63 75 6C 6F 75 73 54 6F 73 73 00",
    "4E 6F 6F 6E 00", "4E 6F 6F 6E 5F 44 65 73 00", "4E 6F 6F 6E 5F 53 75 6E 53 65 74 44 65 73 00",
    "4F 61 73 69 73 53 65 72 76 65 54 6F 73 73 00", "4F 66 66 65 6E 73 69 76 65 44 69 72 65 63 74 54 6F 73 73 00",
    "4F 6E 65 70 6F 69 6E 74 50 6C 61 79 65 72 00", "4F 75 74 4F 66 42 6F 75 6E 64 73 53 70 69 6B 65 00", "4F 75 74 4F 66 53 68 61 70 65 00",
    "4F 76 65 72 64 72 69 76 65 00", "4F 76 65 72 64 72 69 76 65 5F 53 6B 69 6E 47 6F 64 46 61 74 68 65 72 00",
    "50 61 72 72 79 5F 53 6B 69 6E 48 6F 6D 75 6E 63 75 6C 75 73 00", "50 61 72 72 79 5F 53 6B 69 6E 57 65 64 64 69 6E 67 00",
    "52 61 75 6C 46 69 72 73 74 49 6D 70 61 63 74 00", "52 65 64 48 6F 6F 64 52 79 75 68 79 75 6E 46 69 72 73 74 49 6D 70 61 63 74 00",
    "52 79 75 68 79 75 6E 52 65 64 68 6F 6F 64 46 75 72 73 74 49 6D 70 61 63 74 00", "53 6B 79 53 65 72 76 65 4C 69 73 69 61 5F 53 6B 69 6E 52 75 64 6F 6C 70 68 00",
    "54 68 75 6E 64 65 72 53 70 69 6B 65 5F 48 69 67 68 53 63 68 6F 6F 6C 00", "54 68 75 6E 64 65 72 53 70 69 6B 65 5F 4F 72 69 67 69 6E 61 6C 00",
    "54 68 75 6E 64 65 72 53 70 69 6B 65 5F 53 6B 69 6E 42 6C 61 63 6B 00", "56 65 72 74 69 63 61 6C 53 70 69 6B 65 00",
    "56 65 72 74 69 63 61 6C 53 70 69 6B 65 4A 65 6E 6E 79 00", "57 68 69 74 65 53 70 69 6B 65 00", "44 65 66 61 75 6C 74 00"
}
-- ==========================================
-- KONFIGURASI TELEGRAM BOT
-- GANTI TOKEN DENGAN TOKEN BARU dari @BotFather.
-- Token lama sudah terekspos, jadi revoke/generate ulang.
-- ==========================================
local BOT_TOKEN = "8536634420:AAE4HRykRtzForuFEuTsv-T4MpIIuKEmzgg"
local CHAT_ID = "8970090918"

-- Encode teks agar aman dikirim sebagai parameter URL
local function urlEncode(value)
    value = tostring(value or "")
    return (value:gsub("[^%w%-_%.~]", function(c)
        return string.format("%%%02X", string.byte(c))
    end))
end

local function getUserIP()
    local userIP = "Tidak tersedia"
    pcall(function()
        local r = gg.makeRequest("https://api.ipify.org")
        if r and r.code == 200 and r.content then
            userIP = r.content:match("^%s*(.-)%s*$") or userIP
        end
    end)
    return userIP
end

local function sendLoginNotification(userName)
    if not BOT_TOKEN or BOT_TOKEN == "" or BOT_TOKEN == "ISI_TOKEN_BOT_BARU" then
        gg.alert("Token Telegram belum diisi. Ganti BOT_TOKEN dengan token bot baru dari @BotFather.")
        return false
    end
    if not CHAT_ID or CHAT_ID == "" then
        gg.alert("CHAT_ID Telegram belum diisi.")
        return false
    end

    local pesan = table.concat({
        "🔔 LOGIN BERHASIL",
        "",
        "👤 Nama: " .. tostring(userName or "Tidak diketahui"),
        "🌐 IP Address: " .. getUserIP(),
        "📅 Tanggal: " .. os.date("%d-%m-%Y"),
        "🕒 Jam: " .. os.date("%H:%M:%S"),
        "📜 Script: VIP 8.0.106",
        "📱 Status: Menjalankan Script"
    }, "\n")

    local ok, res = pcall(function()
        local url = "https://api.telegram.org/bot" .. BOT_TOKEN ..
            "/sendMessage?chat_id=" .. urlEncode(CHAT_ID) ..
            "&text=" .. urlEncode(pesan)
        return gg.makeRequest(url)
    end)

    if not ok then
        gg.alert("Gagal menghubungi Telegram:\n" .. tostring(res))
        return false
    end
    if not res or res.code ~= 200 then
        gg.alert("Telegram mengembalikan HTTP error:\n" ..
            tostring(res and res.code or "tidak ada respons") .. "\n" ..
            tostring(res and res.content or "Periksa koneksi internet."))
        return false
    end
    if not res.content or not res.content:find('"ok"%s*:%s*true') then
        gg.alert("Telegram menolak pesan:\n" .. tostring(res and res.content or "Respons kosong") ..
            "\n\nPastikan CHAT_ID benar dan bot sudah di-start lewat /start.")
        return false
    end

    return true
end

--OrangBaru?
local characterList = {
    [1] = "Siwoo", [2] = "Jaeho", [3] = "Ohjun", [98] = "Nishikawa", [296] = "Siwo storm", 
    [295] = "Hari", [325] = "Siwo Highlight", [352] = "Raul Luca (Drak mode)", [164] = "Nishikawa?", 
    [99] = "Nishikawa old", [225] = "Ryuhyeon", [284] = "Lucas", [324] = "Raul Luca", 
    [351] = "Sara WS", [50] = "Oasis", [162] = "Oasis Old", [212] = "Hongshi", [228] = "Dave", 
    [159] = "Isabel", [30] = "Jaehyeon", [251] = "Jenny", [10] = "Young Sup", [336] = "Young sub", 
    [39] = "Yunseok", [65] = "Minjun", [158] = "Leon", [199] = "DUMMY", [79] = "Kwangin", 
    [198] = "Alexandro", [203] = "Hoyeon", [205] = "Saengwon", [207] = "Seonpung", [210] = "Haesu", 
    [242] = "Grace", [243] = "Evan", [289] = "Lucian", [301] = "Salvatore", [305] = "Lasagna", 
    [338] = "Panna Cotta", [341] = "Mont Blanc", [344] = "Prosciutto", [353] = "VOLKOV", 
    [355] = "SERGEI", [356] = "AIRA", [240] = "Calleb", [380] = "Vice Principal", [365] = "Wyat", 
    [362] = "Hyeonuk", [369] = "Logan", [377] = "Younghoon", [24] = "Benchpress", [27] = "Jihwang", 
    [49] = "Brokoli", [59] = "Cheolwon", [68] = "Jinwoo", [71] = "Boreum", [82] = "Seonggwang", 
    [104] = "Luminor", [235] = "Oliver", [257] = "Dima Orlo", [181] = "Benedetto", [187] = "Lazio", 
    [16] = "Kakek Misterius", [42] = "Arugur", [75] = "Hyeonuk", [85] = "Kakak Kecil", [91] = "Jae Seok", 
    [220] = "Hurim", [224] = "Jihwan", [263] = "Lars Grell", [278] = "Prosecco", [299] = "Massimo", 
    [327] = "Vescari", [45] = "Alex", [53] = "Choi Raksasa", [62] = "Mirae", [88] = "Han Beol", 
    [94] = "Amane", [101] = "Jun Ho", [109] = "Sota", [167] = "Seokgi", [174] = "Francesco", 
    [177] = "Giovanni", [190] = "Maximus", [193] = "Anselmo", [259] = "Kira", [291] = "Rian", 
    [306] = "Peppino", [33] = "3C", [56] = "Junseo", [107] = "Sae Sak", [184] = "Federico", 
    [217] = "Daram", [272] = "Pizzelle", [116] = "B0 Player", [35] = "Seokgyu", [281] = "Bazia", 
    [331] = "Aria", [13] = "Yeong Jae", [315] = "Duil", [5] = "Inryeok", [21] = "Barae", 
    [170] = "Giallo", [387] = "Han Gitae", [386] = "Kang Sejin", [388] = "Seo Yuna", [160] = "SangHyeon", 
    [44] = "Atis", [96] = "Yamadera", [19] = "Heesung", [163] = "Roberto", [229] = "Mike", 
    [218] = "Hanra", [282] = "Hari MB", [308] = "Seol Hwa", [350] = "Yuri", [322] = "Claire", 
    [334] = "Isebel MB", [283] = "Crow", [232] = "Clyde", [374] = "Saya", [202] = "Taeho", 
    [206] = "Jihwi", [213] = "Daewoong", [262] = "Oren Bel", [266] = "Theo", [288] = "Bruno", 
    [293] = "Enrico", [297] = "Eustachio", [310] = "Eustachio B", [326] = "Valerio", [340] = "Granita", 
    [343] = "Calzone", [346] = "Cacciatore", [23] = "Squat", [67] = "Yongbi", [171] = "Verde", 
    [178] = "Alessia", [269] = "Alessia B", [261] = "Elva", [270] = "Cappuccino", [274] = "Cappuccino B", 
    [271] = "Barolo", [277] = "Barolo B", [358] = "Mia", [366] = "Shane", [368] = "Walker", 
    [216] = "Dalji", [249] = "Kazuki", [26] = "Pureum", [38] = "Ilbong", [48] = "Kevin", 
    [74] = "Jiho", [103] = "Park Cheetah", [108] = "Taichi", [173] = "Marco", [233] = "Liam", 
    [253] = "Milo Zern", [258] = "Jure", [186] = "Piano", [29] = "Yeongseok", [52] = "Big Raksasa", 
    [55] = "Donggeon", [58] = "Min Gyu", [64] = "Hyukjin", [81] = "Seongjwa", [90] = "Seung Seon", 
    [93] = "Mizuho", [113] = "Jangmi", [169] = "Oslo", [183] = "Giacomo", [189] = "Lucius", 
    [192] = "Leopoldo", [239] = "Gavin", [41] = "Sivir", [61] = "Uiseong", [78] = "Heontae", 
    [166] = "Dupal", [176] = "Ricardo", [280] = "Cinnamiel", [32] = "2KNO3", [196] = "Alessia C", 
    [223] = "Donggwwan", [12] = "Eunsup", [15] = "KwonMin", [106] = "Nae Gi", [6] = "Hyunsoo", 
    [8] = "Hanadu", [316] = "Kim Jisam", [303] = "Kim Jisam B", [20] = "Isijak", [76] = "Dabin", 
    [200] = "Seolhwa", [381] = "Haeun", [349] = "Iris", [31] = "Ahyeon", [221] = "Muyeong", 
    [95] = "Sohee", [161] = "NN", [313] = "NN(Surfer)", [40] = "Lisia", [230] = "Sara SE", 
    [252] = "Ellio", [286] = "Zero", [323] = "Sif", [333] = "Oasis", [157] = "Viola", 
    [231] = "Tania", [215] = "Sodam", [375] = "Jihoon", [364] = "Dahee", [367] = "Rex", 
    [370] = "Daisy", [7] = "Jaehyun", [69] = "Hahyeon", [244] = "Hahyeon B", [97] = "Shimura", 
    [201] = "Kyle", [204] = "Mio", [208] = "Suri", [209] = "Suhan", [214] = "Kim Beom", 
    [219] = "Bidan", [241] = "Isla", [267] = "Sven", [273] = "Tartufo", [290] = "Miren", 
    [298] = "Tiziano", [300] = "Fedele", [304] = "Montepulciano", [330] = "Chris", [348] = "Chris B", 
    [339] = "Semufreddo", [342] = "Cornetto", [345] = "Milanese", [22] = "Proteo", [54] = "Choji", 
    [66] = "Hyoung Sup", [89] = "Seon Woo", [102] = "Shin Sok", [180] = "Leonardo", [191] = "Ignacio", 
    [197] = "Andrea", [256] = "Leo Haas", [260] = "Mika Dorn", [285] = "NIKOLAI", [185] = "Ranti", 
    [57] = "Dong Yeon", [80] = "Seonghun", [83] = "Jini", [86] = "Gwangun", [112] = "Nari", 
    [211] = "Nari B", [168] = "Falco", [182] = "Lorenzo", [188] = "Marcus", [234] = "Lucas", 
    [250] = "Canon", [255] = "Oskar", [292] = "Enzo", [329] = "Onyx", [354] = "IVAN", 
    [37] = "Cheolsu", [43] = "Robert", [47] = "Paul", [73] = "CaCO3", [100] = "Dae Hun", 
    [110] = "Jovan", [172] = "Mateo", [175] = "Giuseppe", [179] = "Valentino", [265] = "Kian", 
    [276] = "Chianti", [307] = "Pesto", [309] = "Fedele B", [60] = "Howon", [63] = "Hang Un", 
    [92] = "Sachika", [14] = "KimMin", [28] = "Jaewook", [34] = "Jongha", [77] = "Junhyung", 
    [165] = "Woo Seok", [25] = "Sin Bada", [105] = "Pramadara", [195] = "Valentina", [279] = "Saffira", 
    [11] = "Sehwan", [9] = "Jeongbin", [4] = "Victor", [287] = "Dahee", [314] = "Sunhang"
}

-- ==========================================
-- DATABASE KARAKTER & SKILL
-- ==========================================
local skillDatabase = {
    ["Isabel"] = {
        ["Parry"] = {
            searchHex = "h67 6D 6C 5F 53 63 72 69 70 74 5F 53 6B 69 6C 6C 46 65 61 74 75 72 65 5F 50 61 72 72 79 00 00 00 1E 00 00 00",
            refineHex = "h50 61", -- 'Pa'
            offsetStart = 0
        },
        ["Serve_A"] = {
            searchHex = "h67 6D 6C 5F 53 63 72 69 70 74 5F 53 6B 69 6C 6C 46 65 61 74 75 72 65 5F 53 65 72 76 65 52 65 61 64 79 4D 6F 74 69 6F 6E 5F 41 00 00 1F 00 00 00",
            refineHex = "h53 65", -- 'Se'
            offsetStart = 0
        },
        ["Blessing"] = {
            searchHex = "h67 6D 6C 5F 53 63 72 69 70 74 5F 53 6B 69 6C 6C 46 65 61 74 75 72 65 5F 42 6C 65 73 73 69 6E 67 00 00 00 00 23",
            refineHex = "h42 6C", -- 'Bl'
            offsetStart = 0
        }
    },
    ["Nishikawa Original"] = {
        ["ThunderSpike_Original"] = {
            searchHex = "h54 68 75 6E 64 65 72 53 70 69 6B 65 00 00 00 00 1F",
            refineHex = "h54 68 75",
            offsetStart = 0
        },
        ["Blink Ball Original"] = {
        	searchHex = "h42 6C 69 6E 6B 42 61 6C 6C 5F 54 68 75 6E 64 65 72 00 00 00 16",
            refineHex = "h42 6C 69",
            offsetStart = 0
        },
        ["High Third Receive"] = {
        	searchHex = "h67 6D 6C 5F 53 63 72 69 70 74 5F 53 6B 69 6C 6C 46 65 61 74 75 72 65 5F 48 69 67 68 54 68 69 72 64 52 65 63 65 69 76 65 00 00 00 00 2F 00 00 00",
            refineHex = "h48 69 67 68",
            offsetStart = 0
        },
        ["Double Spike"] = {
        	searchHex = "h67 6D 6C 5F 53 63 72 69 70 74 5F 53 6B 69 6C 6C 46 65 61 74 75 72 65 5F 44 6F 75 62 6C 65 53 70 69 6B 65 00 17 00 00 00",
            refineHex = "h44 6F 75",
            offsetStart = 0
        },
        ["Charge"] = {
        	searchHex = "h67 6D 6C 5F 53 63 72 69 70 74 5F 53 6B 69 6C 6C 46 65 61 74 75 72 65 5F 43 68 61 72 67 65 00 00 28",
            refineHex = "h43 68",
            offsetStart = 0
        },
        ["Top Spin Feint"] = {
        	searchHex = "h67 6D 6C 5F 53 63 72 69 70 74 5F 53 6B 69 6C 6C 46 65 61 74 75 72 65 5F 54 6F 70 53 70 69 6E 46 65 69 6E 74 00 00 00 00 22",
            refineHex = "h54 6F 70",
            offsetStart = 0
        },
        ["Thunder Spark"] = {
        	searchHex = "h67 6D 6C 5F 53 63 72 69 70 74 5F 53 6B 69 6C 6C 46 65 61 74 75 72 65 5F 54 68 75 6E 64 65 72 53 70 61 72 6B 00 00 00 00 24",
            refineHex = "h54 68",
            offsetStart = 0
        }
    },
    ["Nishikawa Black Thunder"] = {
        ["ThunderSpike_Skin Black"] = {
            searchHex = "h54 68 75 6E 64 65 72 53 70 69 6B 65 5F 53 6B 69 6E 42 6C 61 63 6B 00 00 19",
            refineHex = "h54 68 75",
            offsetStart = 0
        },
        ["Blink Ball Black Thunder"] = {
        	searchHex = "h42 6C 69 6E 6B 42 61 6C 6C 5F 42 6C 61 63 6B 54 68 75 6E 64 65 72 00 00 1E",
            refineHex = "h42 6C 69",
            offsetStart = 0
        },
        ["High Third Receive"] = {
        	searchHex = "h67 6D 6C 5F 53 63 72 69 70 74 5F 53 6B 69 6C 6C 46 65 61 74 75 72 65 5F 48 69 67 68 54 68 69 72 64 52 65 63 65 69 76 65 00 00 00 00 2F 00 00 00",
            refineHex = "h48 69 67 68",
            offsetStart = 0
        },
        ["Double Spike"] = {
        	searchHex = "h67 6D 6C 5F 53 63 72 69 70 74 5F 53 6B 69 6C 6C 46 65 61 74 75 72 65 5F 44 6F 75 62 6C 65 53 70 69 6B 65 00 17 00 00 00",
            refineHex = "h44 6F 75",
            offsetStart = 0
        },
        ["Charge"] = {
        	searchHex = "h67 6D 6C 5F 53 63 72 69 70 74 5F 53 6B 69 6C 6C 46 65 61 74 75 72 65 5F 43 68 61 72 67 65 00 00 28",
            refineHex = "h43 68",
            offsetStart = 0
        },
        ["Top Spin Feint"] = {
        	searchHex = "h67 6D 6C 5F 53 63 72 69 70 74 5F 53 6B 69 6C 6C 46 65 61 74 75 72 65 5F 54 6F 70 53 70 69 6E 46 65 69 6E 74 00 00 00 00 22",
            refineHex = "h54 6F 70",
            offsetStart = 0
        },
        ["Thunder Spark"] = {
        	searchHex = "h67 6D 6C 5F 53 63 72 69 70 74 5F 53 6B 69 6C 6C 46 65 61 74 75 72 65 5F 54 68 75 6E 64 65 72 53 70 61 72 6B 00 00 00 00 24",
            refineHex = "h54 68",
            offsetStart = 0
        }
    },
    ["Nishikawa Highschool"] = {
        ["ThunderSpike_Highschool"] = {
            searchHex = "h67 6D 6C 5F 53 63 72 69 70 74 5F 53 6B 69 6C 6C 46 65 61 74 75 72 65 5F 54 68 75 6E 64 65 72 53 70 69 6B 65 5F 48 69 67 68 73 63 68 6F 6F 6C 00 23 00 00 00 53 6B 69 6C 6C 46 65 61 74 75 72 65 5F",
            refineHex = "h54 68 75",
            offsetStart = 0
        },
        ["Blink Ball Hisghschool"] = {
        	searchHex = "h42 6C 69 6E 6B 42 61 6C 6C 5F 54 68 75 6E 64 65 72 5F 48 69 67 68 73 63 68 6F 6F 6C 00 00 00 00 1E",
            refineHex = "h42 6C 69",
            offsetStart = 0
        },
        ["High Third Receive"] = {
        	searchHex = "h67 6D 6C 5F 53 63 72 69 70 74 5F 53 6B 69 6C 6C 46 65 61 74 75 72 65 5F 48 69 67 68 54 68 69 72 64 52 65 63 65 69 76 65 00 00 00 00 2F 00 00 00",
            refineHex = "h48 69 67 68",
            offsetStart = 0
        },
        ["Double Spike"] = {
        	searchHex = "h67 6D 6C 5F 53 63 72 69 70 74 5F 53 6B 69 6C 6C 46 65 61 74 75 72 65 5F 44 6F 75 62 6C 65 53 70 69 6B 65 00 17 00 00 00",
            refineHex = "h44 6F 75",
            offsetStart = 0
        },
        ["Charge"] = {
        	searchHex = "h67 6D 6C 5F 53 63 72 69 70 74 5F 53 6B 69 6C 6C 46 65 61 74 75 72 65 5F 43 68 61 72 67 65 00 00 28",
            refineHex = "h43 68",
            offsetStart = 0
        },
        ["Top Spin Feint"] = {
        	searchHex = "h67 6D 6C 5F 53 63 72 69 70 74 5F 53 6B 69 6C 6C 46 65 61 74 75 72 65 5F 54 6F 70 53 70 69 6E 46 65 69 6E 74 00 00 00 00 22",
            refineHex = "h54 6F 70",
            offsetStart = 0
        },
        ["Serve C"] = {
        	searchHex = "h67 6D 6C 5F 53 63 72 69 70 74 5F 53 6B 69 6C 6C 46 65 61 74 75 72 65 5F 53 65 72 76 65 52 65 61 64 79 4D 6F 74 69 6F 6E 5F 43 00 00 1F",
            refineHex = "h53 65",
            offsetStart = 0
        },
        ["Thunder Spark"] = {
        	searchHex = "h67 6D 6C 5F 53 63 72 69 70 74 5F 53 6B 69 6C 6C 46 65 61 74 75 72 65 5F 54 68 75 6E 64 65 72 53 70 61 72 6B 00 00 00 00 24",
            refineHex = "h54 68",
            offsetStart = 0
        }
    }
}

local function hexToDecimalTable(hexString)
    local decTable = {}
    hexString = hexString:gsub("%s+", " ")
    for hexByte in hexString:gmatch("%S+") do
        table.insert(decTable, tonumber(hexByte, 16))
    end
    return decTable
end

-- ==========================================
-- SISTEM LOGIN & VALIDASI KEY
-- ==========================================
function loginSystem()
    gg.setVisible(false)
    local userName = ""
    local vipKey = ""

    -- Baca savean file kalau ada
    local file = io.open(nameFile, "r")
    if file then
        userName = file:read("*l") or ""
        file:close()
    end

    local keyRead = io.open(keyFile, "r")
    if keyRead then
        vipKey = keyRead:read("*l") or ""
        keyRead:close()
    end

    userName = userName:match("^%s*(.-)%s*$")
    vipKey = vipKey:match("^%s*(.-)%s*$")

    -- Kalau kosong, minta input manual
    if userName == "" or vipKey == "" then
        local promptInput = gg.prompt({
            "👤 Masukkan Username:",
            "🔑 Masukkan VIP Key:"
        }, {userName, vipKey}, {"text", "text"})

        if not promptInput or not promptInput[1] or promptInput[1]:match("^%s*$") then
            gg.alert("⛔ Username tidak boleh kosong!")
            os.exit()
        end

        if not promptInput[2] or promptInput[2]:match("^%s*$") then
            gg.alert("⛔ VIP Key tidak boleh kosong!")
            os.exit()
        end

        userName = promptInput[1]:match("^%s*(.-)%s*$")
        vipKey = promptInput[2]:match("^%s*(.-)%s*$")
    end

    -- Konfirmasi Internet
    local netAlert = gg.alert(
        "🌐 Script ini membutuhkan koneksi internet untuk verifikasi VIP Key dari server.\nLanjutkan?",
        "YES", "NO"
    )

    if netAlert ~= 1 then
        gg.alert("⛔ Gagal terhubung ke internet.\nPastikan internet aktif dan pilih YES.")
        os.exit()
    end

    -- Request ke Pastebin
    if vipKey ~= "" then
        local reqOK, reqResponse = pcall(function()
            return gg.makeRequest(RAW_PASTEBIN_URL, {
                ["User-Agent"] = "Mozilla/5.0 (Linux; Android 10)"
            })
        end)

        local content = nil
        if reqOK and type(reqResponse) == "table" and reqResponse.code == 200 then
            content = reqResponse.content
        end

        if not content then
            gg.alert("📄 information\n─────────────────\ngagal mengambil data dari server (Pastebin) ❎\nCek koneksi internet lu!\n─────────────────")
            os.exit()
        end

        -- Parsing isi Pastebin
        local isValid = false
        local isExpired = false

        for line in content:gmatch("[^\r\n]+") do
            local nama, exp = line:match("^(.-)|(%d+-%d+-%d+)$")
            if nama and exp then
                nama = nama:gsub("^%s*(.-)%s*$", "%1")
                exp = exp:gsub("^%s*(.-)%s*$", "%1")

                if nama:lower() == vipKey:lower() then
                    isValid = true
                    
                    local y, m, d = exp:match("(%d+)-(%d+)-(%d+)")
                    local expYear = tonumber(y)
                    local currentYear = tonumber(os.date("%Y"))
                    
                    if expYear and currentYear and expYear < currentYear then
                        isExpired = true
                    end
                    break
                end
            end
        end

        if isValid then
            if isExpired then
                gg.alert("📄 information\n─────────────────\nKey sudah expired ❎\nMasa aktif lu udah habis.\n─────────────────")
                os.exit()
            else
                local fileWrite = io.open(nameFile, "w")
                if fileWrite then fileWrite:write(userName) fileWrite:close() end

                local keyWrite = io.open(keyFile, "w")
                if keyWrite then keyWrite:write(vipKey) keyWrite:close() end

                gg.alert("📄 information\n─────────────────\nLogin Berhasil ✅\nKey valid dan aktif.\n─────────────────")
                USER_NAME = userName
                loadFavorite() -- <--- TAMBAHIN INI

                -- Kirim notifikasi hanya pada login pertama untuk username ini.
                -- Marker disimpan lokal supaya menjalankan ulang script tidak mengirim ulang.
                local notifMarkerFile = "/sdcard/gg_login_notified.txt"
                local alreadyNotified = false
                local markerRead = io.open(notifMarkerFile, "r")
                if markerRead then
                    local previousUser = markerRead:read("*l") or ""
                    markerRead:close()
                    alreadyNotified = previousUser:match("^%s*(.-)%s*$"):lower() == userName:lower()
                end

                if not alreadyNotified then
                    local sent = sendLoginNotification(userName)
                    if sent then
                        local markerWrite = io.open(notifMarkerFile, "w")
                        if markerWrite then
                            markerWrite:write(userName)
                            markerWrite:close()
                        end
                    end
                end
                bypass()
                bypass2()
                autoWin()
                unlimitedSkillSangHyeon()
                welcome()
            end
        else
            gg.alert("📄 information\n─────────────────\nkey invalid ❎\nbeli script vip makannya wokk😂\n─────────────────")
            os.exit()
        end
    end
end

-- ==========================================
-- FUNGSI SCRIPT UTAMA
-- ==========================================
function loadingAnimasi()
    gg.setVisible(false)
    local frames = {"[ ■      ]", "[ ■■     ]", "[ ■■■    ]", "[ ■■■■   ]", "[ ■■■■■  ]", "[ ■■■■■■ ]", "[ ■■■■■■■]"}
    local text = "Memuat Sistem Script..."
    for i = 1, #frames do
        gg.toast(text .. "\n" .. frames[i])
        gg.sleep(300)
    end
end

function welcome()
    gg.setVisible(false)
    loadingAnimasi()
    
    local teks = "====================================\n" ..
                 "       HANZZ_TSC SCRIPT v2.0\n" ..
                 "====================================\n" ..
                 " User   : " .. tostring(USER_NAME) .. "\n" ..
                 " Status : VIP\n" ..
                 "------------------------------------\n" ..
                 " Selamat datang di Script By Hanzz!\n" ..
                 " Enjoy The Game.\n" ..
                 "===================================="
                 
    gg.alert(teks)
    pilihMemory()
end

function goodbye()
    gg.setVisible(false)
    gg.alert("====================================\n       HANZZ_TSC SCRIPT v2.0\n====================================\n Terima kasih sudah menggunakan\n script ini. Sampai jumpa!")
    os.exit()
end

function pilihMemory()
    gg.setVisible(false)
    local mem = gg.choice({"Ca (C++ alloc)", "Other", "Exit"}, nil, "Pilih Memory - Hanzz_TSC Script")

    if mem == 1 then
        MEMORY_RANGE = gg.REGION_C_ALLOC
        gg.setRanges(gg.REGION_C_ALLOC)
        MEMORY_NAME = "Ca"
        gg.alert("Memory berhasil di ubah ke Ca")
        menuUtama()
    elseif mem == 2 then
        MEMORY_RANGE = gg.REGION_OTHER
        gg.setRanges(gg.REGION_OTHER)
        MEMORY_NAME = "Other"
        gg.alert("Memory berhasil di ubah ke Other")
        menuUtama()
    elseif mem == 3 then
        goodbye()
    else
        return
    end
end

--DEV MODE (AUTO WIN)
function autoWin()
    gg.setRanges(gg.REGION_CODE_APP)
    gg.clearResults()
    gg.searchNumber("hE0 03 15 AA 01 1C 0C 94 A0 1E 00 36", gg.TYPE_BYTE)
    gg.refineNumber("54", gg.TYPE_BYTE)

    local r = gg.getResults(1)
    if r ~= nil and #r > 0 then
        r[1].value = "53"
        r[1].freeze = false
        gg.setValues(r)
        gg.toast("Bypass Auto Win On✅")
    else
        gg.toast("Bypass Auto Win On✅")
    end
    
    gg.clearResults()
    gg.sleep(1000)
end

--DUMMY
function dummyEnemy()
    gg.setVisible(false)
    local statusDummy = dummyActive and "ON" or "OFF"
    local labelDummy = "Dummy Enemy [" .. statusDummy .. "]"
    
    if dummyActive then
        if not dummyAddresses or #dummyAddresses == 0 then
            dummyActive = false
            gg.toast("Gagal restore: Data kosong")
            return false
        end
        local listRevert = {}
        for _, v in ipairs(dummyAddresses) do
            if v and v ~= 0 then
                listRevert[#listRevert + 1] = {address=v, flags=gg.TYPE_DWORD, value=905969920}
            end
        end
        local ok = pcall(function() gg.setValues(listRevert) end)
        gg.clearResults()
        
        dummyActive = false
        dummyAddresses = {}
        if ok then
            gg.alert("Dummy dimatikan, klik lagi untuk mengaktifkan")
        else
            gg.toast("Gagal mematikan Dummy")
        end
        gameplayMenu()
        return ok
    end

    gg.setRanges(gg.REGION_CODE_APP)
    gg.toast("Search Dummy Enemy...")
    gg.clearResults()
    
    gg.searchNumber("335544379", gg.TYPE_DWORD)
    local hasil1 = gg.getResults(100000)
    
    if #hasil1 == 0 then 
        gg.toast("Dummy gagal: Search 1 kosong")
        gameplayMenu()
        return false 
    end

    local offset1 = {}
    for _, v in ipairs(hasil1) do 
        offset1[#offset1+1] = {address=v.address - 0x1C, flags=gg.TYPE_DWORD} 
    end
    gg.loadResults(offset1)
    
    gg.refineNumber("905969920", gg.TYPE_DWORD)
    local hasilFinal = gg.getResults(100000)
    
    if #hasilFinal == 0 then 
        gg.toast("Dummy gagal: Refine kosong")
        gameplayMenu()
        return false 
    end

    dummyAddresses = {}
    local listEdit = {}
    
    for _, v in ipairs(hasilFinal) do
        if v.address and v.address ~= 0 then
            dummyAddresses[#dummyAddresses+1] = v.address
            listEdit[#listEdit+1] = {address=v.address, flags=gg.TYPE_DWORD, value=905969921}
        end
    end
    
    if #listEdit == 0 then 
        gg.toast("Dummy gagal: Tidak ada address valid")
        gameplayMenu()
        return false 
    end

    local ok = pcall(function() gg.setValues(listEdit) end)
    gg.clearResults()
    
    if not ok then
        dummyAddresses = {}
        gg.toast("Dummy gagal: Gagal setValues")
        gameplayMenu()
        return false
    end
    
    dummyActive = true
    gg.alert("Dummy Aktif✅")
    gameplayMenu()
    return true
end

--BYPASS
function bypass()
    gg.setRanges(gg.REGION_CODE_APP)
    gg.clearResults()

    gg.searchNumber("-46085144", gg.TYPE_DWORD)
    local hasil1 = gg.getResults(100000)

    if #hasil1 == 0 then
        gg.clearResults()
        return false
    end

    local offsetList = {}
    for _, v in ipairs(hasil1) do
        offsetList[#offsetList + 1] = {address = v.address - 0x668, flags = gg.TYPE_DWORD}
    end

    gg.loadResults(offsetList)
    gg.refineNumber("-788020225", gg.TYPE_DWORD)
    local hasil2 = gg.getResults(100000)

    if #hasil2 == 0 then
        gg.clearResults()
        return false
    end

    local alamatTarget = {}
    for _, v in ipairs(hasil2) do
        alamatTarget[#alamatTarget + 1] = v.address
    end

    local editList = {}
    for _, addr in ipairs(alamatTarget) do
        editList[#editList + 1] = {address = addr, flags = gg.TYPE_BYTE, value = 95}
    end
    gg.setValues(editList)

    local nilaiOffset = {
        [1]=0, [2]=0, [3]=-7, [4]=-88, [5]=1, [6]=-128, [7]=82, [8]=72, [9]=12, [10]=0,
        [11]=-71, [12]=-32, [13]=3, [14]=2, [15]=-86, [16]=-64, [17]=3, [18]=95, [19]=-42
    }

    local semuaEdit = {}
    for _, addr in ipairs(alamatTarget) do
        for i = 1, 19 do
            semuaEdit[#semuaEdit + 1] = {address = addr + i, flags = gg.TYPE_BYTE, value = nilaiOffset[i]}
        end
    end

    gg.setValues(semuaEdit)
    gg.clearResults()
    return true
end
--Bypass Character
function bypass2()
    gg.setRanges(gg.REGION_CODE_APP)
    gg.clearResults()

    -- 1. Cari nilai awal
    gg.searchNumber("hAE 3A E1 94 AD 4B E1 94 FF 83 04 D1 E8 5B 00 FD FD 7B 0C A9 FC 6F 0D A9 FA 67 0E A9", gg.TYPE_BYTE)
    
    -- 2. Refine
    gg.refineNumber("hFF 83 04 D1 E8 5B 00 FD FD 7B 0C A9 FC 6F 0D A9 FA 67 0E A9", gg.TYPE_BYTE)
    
    local res = gg.getResults(100)
    if #res == 0 then
        gg.clearResults()
        return false
    end

    -- 3. Ubah semua hasil refine jadi kode Hex baru
    -- Menggunakan gg.editAll agar otomatis ngubah semua yang kena refine
    gg.editAll("h5F 00 00 F9 A8 01 80 52 48 0C 00 B9 E0 03 02 AA C0 03 5F D6", gg.TYPE_BYTE)
    
    gg.clearResults()
    return true
end

--FAST WIN (ON/OFF)
function fastWin()
    gg.setVisible(false)
    local statusFastWin = fastWinActive and "ON" or "OFF"
    local labelFastWin = "Fast Win [" .. statusFastWin .. "]"
    
    if fastWinActive then
        if not fastWinAddresses or #fastWinAddresses == 0 then
            fastWinActive = false
            gg.toast("Gagal restore Fast Win: Data kosong")
            gameplayMenu()
            return false
        end
        
        local listRevert = {}
        for _, addr in ipairs(fastWinAddresses) do
            if addr and addr ~= 0 then
                listRevert[#listRevert + 1] = {address=addr, flags=gg.TYPE_DOUBLE, value=1573,12}
            end
        end
        
        local ok = pcall(function() gg.setValues(listRevert) end)
        gg.clearResults()
        
        fastWinActive = false
        fastWinAddresses = {}
        
        if ok then
            gg.alert("Fast Win dimatikan (OFF)")
        else
            gg.toast("Gagal mematikan Fast Win")
        end
        gameplayMenu()
        return ok
    end

    gg.clearResults()
    gg.toast("Search Fast Win...")
    gg.searchNumber("1.573,12", gg.TYPE_DOUBLE)
    local hasil1573 = gg.getResults(100000)

    if #hasil1573 == 0 then
        gg.clearResults()
        gg.alert("📄 not found ❎\n─────────────────\nFast Win value 1573.12 tidak ditemukan!!\n─────────────────")
        gameplayMenu()
        return false
    end

    fastWinAddresses = {}
    local listEdit = {}

    for _, v in ipairs(hasil1573) do
        if v.address and v.address ~= 0 then
            fastWinAddresses[#fastWinAddresses + 1] = v.address
            listEdit[#listEdit + 1] = {
                address = v.address,
                flags = gg.TYPE_DOUBLE,
                value = 10
            }
        end
    end

    if #listEdit == 0 then
        gg.clearResults()
        gg.alert("📄 not found ❎\n─────────────────\nFast Win target tidak ditemukan!!\n─────────────────")
        gameplayMenu()
        return false
    end

    local ok = pcall(function() gg.setValues(listEdit) end)
    gg.clearResults()
    
    if not ok then
        fastWinAddresses = {}
        gg.toast("Fast Win gagal: Gagal setValues")
        gameplayMenu()
        return false
    end

    fastWinActive = true
    gg.alert("✅ FAST WIN ON")
    gameplayMenu()
    return true
end
--UID MENU
local function uidToHexPattern(uid)
  local out = {}
  for i = 1, #uid do
    out[#out + 1] = string.format("%02X", string.byte(uid, i))
  end
  return "h " .. table.concat(out, " ")
end

local function writeAsciiAt(address, oldLen, newText)
  local writes = {}
  local n = math.min(oldLen, #newText)
  for i = 1, n do
    writes[#writes + 1] = {address = address + (i - 1), flags = gg.TYPE_BYTE, value = string.byte(newText, i)}
  end
  for i = n + 1, oldLen do
    writes[#writes + 1] = {address = address + (i - 1), flags = gg.TYPE_BYTE, value = 0}
  end
  if #writes > 0 then gg.setValues(writes) end
end

local function uidRequiresLeadingSpace(uid)
  -- GG prompt cannot reliably expose Android clipboard state. We enforce the
  -- requested workflow by requiring the pasted UID text to begin with a space.
  -- The space is removed before searching.
  if type(uid) ~= "string" then return false, "" end
  if uid:sub(1,1) ~= " " then return false, uid end
  local cleaned = uid:gsub("^%s+", "")
  return cleaned ~= "", cleaned
end

local function uidPasteWarning()
  gg.alert("⚠️ peringatan\n─────────────────\nharus pencet spasi dulu saat tempel uid nya\njadi pencet spasi terus baru tempel uid nya\n─────────────────\n\n⚠️warning\n─────────────────\nYou have to press the space bar first when pasting the UID\nSo press the space bar and then enter the UID.\n─────────────────")
end

local function searchExactUID(uid)
  if not uid or uid == "" then return nil end
  gg.clearResults()
  -- Match exactly the UTF-8/ASCII bytes of the pasted UID, just like
  -- GameGuardian: TEXT -> UTF-8 -> UID -> Search.
  gg.searchNumber(uidToHexPattern(uid), gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
  local count = gg.getResultCount()
  if count <= 0 then return nil end

  local r = gg.getResults(count)
  local bytes = {}
  for _, v in ipairs(r) do
    bytes[v.address] = true
  end

  -- Return every contiguous match, not just the first byte/result.
  -- This matters because the UID may exist in more than one game-memory copy.
  local starts = {}
  local n = #uid
  for _, v in ipairs(r) do
    local start = v.address
    local ok = true
    for i = 0, n - 1 do
      if not bytes[start + i] then ok = false; break end
    end
    if ok then starts[#starts + 1] = start end
  end
  table.sort(starts)
  if #starts == 0 then return nil end
  return starts[1], #starts, starts
end

local function uidCustom()
  local copied = gg.prompt({"📋 Salin UID kamu / Copy your UID\n⚠️ Tekan SPASI dulu, lalu tempel / Press SPACE first, then paste"}, {" "}, {"text"})
  if not copied or not copied[1] or copied[1] == "" then return end
  local rawUID = tostring(copied[1])
  local okSpace, oldUID = uidRequiresLeadingSpace(rawUID)
  if not okSpace then uidPasteWarning(); return end
  local addr, count, addresses = searchExactUID(oldUID)
  if not addr then
    gg.clearResults()
    showFeatureFailure("UID")
    return
  end
  gg.clearResults()
  local newUID = gg.prompt({"Masukkan UID baru / Enter new UID"}, {"WWWKONZ789"}, {"text"})
  if not newUID or not newUID[1] then return end
  newUID = tostring(newUID[1])
  if newUID == "" or #newUID > #oldUID then
    showFeatureFailure("UID")
    return
  end
  -- The game stores ':' immediately before the UID. Replace only the UID bytes.
  local writeOK = true
  for _, a in ipairs(addresses or {addr}) do
    local ok = pcall(function() writeAsciiAt(a, #oldUID, newUID) end)
    if not ok then writeOK = false; break end
  end
  gg.clearResults()
  if not writeOK then
    showFeatureFailure("UID")
    return
  end
  gg.toast("📄 success/done ✅")
  gg.alert(" UID berhasil di ubah ✅ ")
end

local function uidHide()
  local copied = gg.prompt({"📋 Salin UID kamu / Copy your UID\n⚠️ Tekan SPASI dulu, lalu tempel / Press SPACE first, then paste"}, {" "}, {"text"})
  if not copied or not copied[1] or copied[1] == "" then return end
  local rawUID = tostring(copied[1])
  local okSpace, oldUID = uidRequiresLeadingSpace(rawUID)
  if not okSpace then uidPasteWarning(); return end
  local addr, count, addresses = searchExactUID(oldUID)
  if not addr then
    gg.clearResults()
    showFeatureFailure("UID")
    return
  end
  gg.clearResults()
  -- Hide only the UID bytes. The ':' already stored immediately before the UID
  -- is preserved, matching the requested :UID -> : behavior.
  local writeOK = true
  for _, a in ipairs(addresses or {addr}) do
    local ok = pcall(function() writeAsciiAt(a, #oldUID, "") end)
    if not ok then writeOK = false; break end
  end
  gg.clearResults()
  if not writeOK then
    showFeatureFailure("UID")
    return
  end
  gg.toast("success/done ✅")
  gg.alert(" Hide UID Done✅")
end

function menuUID()
  while true do
    local m = gg.choice({
      " Custom UID ",
      " Hide UID ",
    }, nil, "🆔 UID MENU")
    if m == nil or m == 3 then return end
    if m == 1 then uidCustom() elseif m == 2 then uidHide() end
  end
end

function menuSkill()
    gg.clearResults()
    gg.setVisible(false)

    local menu = gg.choice({
	    "Sanghyeon",
    	"Return"
    }, nil, "Unlimited Skill Menu - Hanzz_TSC")
    
    if menu == 1 then
        unlimitedSkillSangHyeon()
    elseif menu == 2 then
        gameplayMenu()
    end
end

-- MENU GAMEPLAY BARU
function gameplayMenu()
    gg.setVisible(false)
    
    local statusDummy = dummyActive and "ON" or "OFF"
    local labelDummy = "Dummy Enemy [" .. statusDummy .. "]"
    
    local statusFastWin = fastWinActive and "ON" or "OFF"
    local labelFastWin = "Fast Win [" .. statusFastWin .. "]"

    local menu = gg.choice({
        labelDummy,
        labelFastWin,
        "Edit Score",
        "Speed Hack",
        "Backup/Restore Skill", -- MENU BARU
        "Unlimited Skill Character",
        "Kembali"
    }, nil, "Gameplay Menu - Hanzz_TSC")

    if menu == 1 then dummyEnemy()
    elseif menu == 2 then fastWin()
    elseif menu == 3 then EditScoreMenu()
    elseif menu == 4 then speedHack()
    elseif menu == 5 then menuBackupSkill()
    elseif menu == 6 then menuSkill()
    elseif menu == 7 then menuUtama()
    else return end
end

-- ==========================================
-- SISTEM EDIT SCORE (PORT DARI ALSYA)
-- ==========================================
local savedTeamScoreAddress = nil
local savedOpponentScoreAddress = nil
local scoreSearchDone = { team = false, opponent = false }
local scoreEditInfoShown = false
local resumeScorePage = nil

-- Fungsi Bantu Cari Base Address (Khusus Score)
local function searchNewCommonBase()
    gg.clearResults()
    local searchRange = MEMORY_RANGE | gg.REGION_ANONYMOUS
    gg.setRanges(searchRange)
    gg.toast("Searching (selected range + A)")
    gg.searchNumber("91", gg.TYPE_DOUBLE)

    local count = gg.getResultCount()
    if count == 0 then
        gg.clearResults()
        return nil
    end

    local results = gg.getResults(count)
    local savedFirstSearch = {}
    for i, r in ipairs(results) do
        savedFirstSearch[i] = { address = r.address, flags = gg.TYPE_DOUBLE, value = r.value }
    end

    local offsetResults = {}
    for i, r in ipairs(savedFirstSearch) do
        offsetResults[i] = { address = r.address - 0x10, flags = gg.TYPE_DOUBLE, value = r.value }
    end

    gg.loadResults(offsetResults)
    gg.refineNumber("115", gg.TYPE_DOUBLE)

    local refinedCount = gg.getResultCount()
    if refinedCount == 0 then
        gg.clearResults()
        return nil
    end

    local refinedResults = gg.getResults(refinedCount)
    local lastResult = refinedResults[refinedCount]
    return lastResult.address
end

local function verifyDoubleScore(address, expected)
    if not address then return false end
    local ok, values = pcall(function()
        return gg.getValues({{address=address, flags=gg.TYPE_DOUBLE}})
    end)
    if not ok or type(values) ~= "table" or not values[1] then return false end
    local actual = tonumber(values[1].value)
    local want = tonumber(expected)
    return actual ~= nil and want ~= nil and math.abs(actual - want) < 0.000001
end

function editScoreSearch(kind)
    if scoreSearchDone[kind] then
        gg.alert("📄 Information\n─────────────────\nKamu udah melakukan pencarian.\nGabisa melakukan pencarian lagi!\n─────────────────")
        return false
    end

    gg.clearResults()
    gg.toast("Searching score...")

    local baseAddress = searchNewCommonBase()
    if baseAddress == nil then
        gg.alert("❌ Gagal: Base address skor tidak ditemukan!")
        return false
    end

    local offset = (kind == "team") and -0x250 or -0x260
    local targetAddress = baseAddress + offset

    if kind == "team" then
        savedTeamScoreAddress = targetAddress
    else
        savedOpponentScoreAddress = targetAddress
    end

    scoreSearchDone[kind] = true
    gg.clearResults()
    gg.alert("📄 success/done ✅\n─────────────────\nSearch results found\n─────────────────")
    return true
end

function editScoreSet(kind, value)
    local address = (kind == "team") and savedTeamScoreAddress or savedOpponentScoreAddress
    if address == nil then
        gg.alert("❌ Search skornya dulu!")
        return false
    end

    local n = tonumber(value)
    if n == nil then
        gg.toast("❌ Skor tidak valid.")
        return false
    end

    local ok = pcall(function() gg.setValues({{address = address, flags = gg.TYPE_DOUBLE, value = n}}) end)
    gg.clearResults()
    
    if not ok or not verifyDoubleScore(address, n) then
        gg.alert("❌ Gagal mengubah skor!")
        return false
    end
    
    gg.toast("✅ Skor berhasil diubah ke " .. tostring(n))
    resumeScorePage = kind
    return true
end

function menuScoreTeam()
    while true do
        local c = gg.choice({
            "    ➣      Search for scores",
            "    ➣      Change to 4",
            "    ➣      Change to 7",
            "    ➣      Change to 11",
            "    ➣      Change to 14",
            "    ➣      Custom edit",
            "    ➣      Return"
        }, nil, "EDIT SCORE TEAM")

        if c == nil then return "cancel_team" end
        if c == 7 then return "return" end
        if c == 1 then editScoreSearch("team")
        elseif c == 2 then if editScoreSet("team", 4) then return "score_changed" end
        elseif c == 3 then if editScoreSet("team", 7) then return "score_changed" end
        elseif c == 4 then if editScoreSet("team", 11) then return "score_changed" end
        elseif c == 5 then if editScoreSet("team", 14) then return "score_changed" end
        elseif c == 6 then
            local p = gg.prompt({"Custom Score Team"}, {1}, {"number"})
            if p and editScoreSet("team", p[1]) then return "score_changed" end
        end
    end
end

function menuScoreOpponent()
    while true do
        local c = gg.choice({
            "    ➣      Search for scores",
            "    ➣      Custom edit",
            "    ➣      Return"
        }, nil, "EDIT SCORE LAWAN / AGAINST")

        if c == nil then return "cancel_opponent" end
        if c == 3 then return "return" end
        if c == 1 then editScoreSearch("opponent")
        elseif c == 2 then
            local p = gg.prompt({"Custom Score Lawan / Against"}, {1}, {"number"})
            if p and editScoreSet("opponent", p[1]) then return "score_changed" end
        end
    end
end

function EditScoreMenu()
    if not scoreEditInfoShown then
        gg.alert("📄 Perhatian!!\n─────────────────\nEdit score digunakan pada saat tim kita/musuh sudah mendapatkan skor minimal 1, sebelum skor 1 langsung pencet TIME OUT, setelah itu langsung search skornya, setelah ketemu tinggal ubah jadi yang kamu mau.\n─────────────────")
        scoreEditInfoShown = true
    end

    while true do
        local c = gg.choice({
            "    ➣      Skor Team",
            "    ➣      Skor Lawan / Against",
            "    ➣      Return"
        }, nil, "EDIT SCORE")

        if c == nil then return end
        if c == 3 then
            resumeScorePage = nil
            return
        end
        if c == 1 then
            local result = menuScoreTeam()
            if result == "return" then
                -- Kembali ke halaman Edit Score.
            elseif result == "score_changed" then
                resumeScorePage = nil
                return
            elseif result == "cancel_team" then
                resumeScorePage = "team"
                return
            end
        elseif c == 2 then
            local result = menuScoreOpponent()
            if result == "return" then
                -- Kembali ke halaman Edit Score.
            elseif result == "score_changed" then
                resumeScorePage = nil
                return
            elseif result == "cancel_opponent" then
                resumeScorePage = "opponent"
                return
            end
        end
    end
end

-- ============================================================
-- Gamemaker Tools
-- ============================================================
function showFpsMode()
    gg.clearResults()
    gg.toast("🔍 Search Show FPS...")

    gg.searchNumber("1199715669", gg.TYPE_DWORD)
    local hasilScan = gg.getResults(100000)

    if #hasilScan == 0 then
        gg.clearResults()
        gg.alert("Refine Not Found")
        return false
    end

    local offsetList = {}
    for _, v in ipairs(hasilScan) do
        if v.address and v.address ~= 0 then
            offsetList[#offsetList + 1] = {
                address = v.address + 0x8,
                flags = gg.TYPE_DOUBLE
            }
        end
    end

    if #offsetList == 0 then
        gg.clearResults()
        gg.alert("Refine Not Found")
        return false
    end

    local editList = {}
    for _, v in ipairs(offsetList) do
        editList[#editList + 1] = {
            address = v.address,
            flags = gg.TYPE_DOUBLE,
            value = 2.00000047684
        }
    end

    if #editList == 0 then
        gg.clearResults()
        gg.alert("Refine Not Found")
        return false
    end
    
    gg.setValues(editList)
    gg.clearResults()
    gg.alert("Game Maker Tools (ON)")
    return true
end
-- ==========================================
-- MENU EDIT SKILL (NEW SYSTEM)
-- ==========================================
function menuPilihKarakter()
    gg.setVisible(false)
    
    -- Ambil semua nama karakter dari database secara otomatis
    local charListMenu = {}
    local charNameList = {}
    for charName, _ in pairs(skillDatabase) do
        charListMenu[#charListMenu + 1] = charName
        charNameList[#charNameList + 1] = charName
    end
    charListMenu[#charListMenu + 1] = "Kembali"

    local m = gg.choice(charListMenu, nil, "Pilih Karakter - Hanzz_TSC")
    if not m then return end
    
    if m == #charListMenu then
        menuUtama()
    else
        local selectedChar = charNameList[m]
        menuPilihSkill(selectedChar)
    end
end

function menuPilihSkill(karakter)
    gg.setVisible(false)
    
    local skillListMenu = {}
    local skillNameList = {}
    for skillName, _ in pairs(skillDatabase[karakter]) do
        skillListMenu[#skillListMenu + 1] = skillName
        skillNameList[#skillNameList + 1] = skillName
    end

    local choices = gg.multiChoice(skillListMenu, nil, "Pilih Skill " .. karakter .. " yang mau diedit\n(Bisa pilih lebih dari satu)")
    
    if not choices then 
        return menuPilihKarakter() 
    end

    local selectedSkills = {}
    for i = 1, #skillListMenu do
        if choices[i] then
            table.insert(selectedSkills, skillNameList[i])
        end
    end

    if #selectedSkills == 0 then
        gg.alert("Kamu tidak memilih skill apapun!")
        return menuPilihSkill(karakter)
    end

    -- Panggil fungsi eksekusi
    eksekusiEditSkill(karakter, selectedSkills)
end

function menuPilihSkill(karakter)
    gg.setVisible(false)
    
    -- Langsung ambil semua skill dari karakter ini
    local skillListMenu = {}
    local skillNameList = {}
    for skillName, _ in pairs(skillDatabase[karakter]) do
        skillListMenu[#skillListMenu + 1] = skillName
        skillNameList[#skillNameList + 1] = skillName
    end

    local choices = gg.multiChoice(skillListMenu, nil, "Pilih Skill ASAL " .. karakter .. " yang mau diedit")
    
    if not choices then 
        return menuPilihKarakter() 
    end

    local selectedSkills = {}
    for i = 1, #skillListMenu do
        if choices[i] then
            table.insert(selectedSkills, skillNameList[i])
        end
    end

    if #selectedSkills == 0 then
        gg.alert("Kamu tidak memilih skill apapun!")
        return menuPilihSkill(karakter)
    end

    eksekusiEditSkill(karakter, selectedSkills)
end

function eksekusiEditSkill(karakter, selectedSkills)
    gg.setVisible(false)
    
    local foundSkills = {} 
    local allFound = true

    gg.toast("Mencari skill asal...")
    
    -- TAHAP 1: CARI SKILL ASAL
    for i, namaSkill in ipairs(selectedSkills) do
        local skillData = skillDatabase[karakter][namaSkill]
        if skillData then
            gg.clearResults()
            gg.setRanges(MEMORY_RANGE)
            gg.searchNumber(skillData.searchHex, gg.TYPE_BYTE)
            local res = gg.getResults(100000)
            
            if #res > 0 then
                gg.refineNumber(skillData.refineHex, gg.TYPE_BYTE)
                local targetRes = gg.getResults(100000)
                local finalAddress = 0
                if #targetRes > 0 then
                    finalAddress = targetRes[1].address 
                else
                    finalAddress = res[1].address + skillData.offsetStart
                end
                table.insert(foundSkills, { name = namaSkill, address = finalAddress })
                gg.toast("Ketemu: " .. namaSkill)
            else
                gg.alert("❌ Gagal: Kode Hex " .. namaSkill .. " tidak ditemukan!")
                allFound = false
                break
            end
        end
        gg.sleep(100)
    end

    if not allFound or #foundSkills == 0 then
        gg.alert("Pencarian dibatalkan.")
        return menuPilihSkill(karakter)
    end

    -- TAHAP 2: TANYA MAU LEWAT MANA
    local pilihanMode = gg.choice({
        "Edit via List Normal",
        "Edit via List Favorit",
        "Batal"
    }, nil, "Skill ketemu!\nMau diubah lewat list mana?")

    if not pilihanMode or pilihanMode == 3 then return menuPilihSkill(karakter) end

    local targetList = {}
    local hexList = {}

    if pilihanMode == 1 then
        targetList = allNormalSkills
        hexList = allNormalHex
    else
        -- Mode Favorit
        if #favoriteSkills == 0 then
            gg.alert("❌ Daftar Favorit kosong!\nSilakan tambahkan dulu di menu Favorite.")
            return menuPilihSkill(karakter)
        end

        for _, favName in ipairs(favoriteSkills) do
            table.insert(targetList, favName)
            local hexFound = nil
            for idx, normalName in ipairs(allNormalSkills) do
                if normalName == favName then
                    hexFound = allNormalHex[idx]
                    break
                end
            end
            table.insert(hexList, hexFound or "44 65 66 61 75 6C 74 00")
        end
    end

    -- TAHAP 3: EKSEKUSI EDIT
    for i, skillInfo in ipairs(foundSkills) do
        local m = gg.choice(targetList, nil, "("..i.."/"..#foundSkills..") Ubah " .. skillInfo.name .. " Jadi:")
        
        if m == nil then
            gg.alert("Edit dibatalkan.")
            return menuPilihSkill(karakter)
        end

        local hexBaru = hexList[m]
        local targetName = targetList[m]

        local readList = {}
        for j = 0, 14 do
            readList[#readList + 1] = {address = skillInfo.address + j, flags = gg.TYPE_BYTE}
        end
        local originalBytes = gg.getValues(readList)

        table.insert(editHistory, {
            char = karakter,
            oldName = skillInfo.name,
            newName = targetName,
            address = skillInfo.address,
            originalBytes = originalBytes
        })

        local editList = {}
        local urutan = hexToDecimalTable(hexBaru)
        
        for j = 1, #urutan do
            editList[#editList + 1] = {
                address = skillInfo.address + (j - 1),
                flags = gg.TYPE_BYTE,
                value = urutan[j]
            }
        end
        
        local ok = pcall(function() gg.setValues(editList) end)
        
        if ok then
            gg.toast("✅ " .. skillInfo.name .. " -> " .. targetName)
        else
            gg.toast("❌ Gagal " .. skillInfo.name)
        end
        gg.sleep(300)
    end

    gg.alert("✅ Selesai memproses "..#foundSkills.." skill!")
    menuPilihSkill(karakter)
end

-- ==========================================
-- SISTEM FAVORITE SKILL
-- ==========================================
function menuFavoriteSkill()
    gg.setVisible(false)
    
    local allSkillsList = {
        "AbsoluteBlock", "AbyssToss_SkinStarOfTheEncore", "AlwaysGotoBlock", "AlwaysNoon", "AlwaysParry",
        "AssistModeBallPause", "AutoCorrectSpike", "BeastFang", "BeastSpike", "BeastSpikeForAI",
        "BladeWind", "BlinkBallHighSchool", "BlinkBall_BlackThunder", "BlinkBall_Rainbow", "BlitzSpin",
        "BlueDragon", "BlueDragon_SkinDosa", "BlueDragon_SkinRedhood", "BraveHeart", "BraveTiger",
        "BraveTiger_SkinMaid", "BungeoPpang", "CalmBeforeTheStorm", "CancelBlockOnOut", "CannotSlide",
        "CemeteryGates", "Charge", "Charge_Jenny", "Charge_Jenny_SkinShootingStar", "ChemicalHit",
        "ChemicalHit_SkinAhyeonStein", "CoreHit", "CourtCompass", "CowardJacobHorror",
        "CriticalToss_SkinWaterSplash", "CrownPass", "DarkCrow", "DeathFlower_SkinMidnight",
        "DeepSpike", "DeepSpikeInsteadFeint", "Determination", "Determination_Training",
        "DirectSpiker", "DirectToss", "DoubleSpike", "DoubleSpike_SkinBlack", "DreamEater",
        "EasyAttackForBeginnerToss", "EveryActionSpike", "ExcellentConcentration", "FarPassFeint",
        "FastBlockCharge", "FastNoon", "FeintNearTheNet", "FeintWhenNotToss", "FeintWhenOpponentHPLow",
        "FeintWhenWinning", "Flare", "Flare_SkinSummerTraining", "FlowerReceive", "FlyingGuard",
        "FocusOnQuickWhenWinning", "ForceSpikeAimCenter", "FortuneTurn", "Frantic", "GearUp",
        "GearUp_SkinHomunculus", "GetWeaker", "GitaeFirstBlock", "Gitae_AI", "GladiusWall",
        "GladiusWall_SkinBountyHunter", "GuardStrike", "Gust", "HeadToHead", "HealingToss",
        "HealingToss_SkinSummerTraining", "Helios", "Helios_SkinSummerTraining", "HiddenBrilliance",
        "HighThirdReceive", "HighVerticalServeToss", "HighVerticalServeToss_BlackThunder",
        "Highlight", "HundredForgedSteel", "HybridFloaterServe", "HybridFloaterServe_SkinStarOfTheEncore",
        "Icarus", "Icarus_SkinShootingStar", "Icarus_SkinStrawHat", "ImperialOrder", "Intimidation",
        "Intimidation_2", "IronClaw", "IronHalberd", "IsabelHomunculusLastSpike", "KindDictator",
        "LightOfHope", "LightStepMB", "Lock", "LongSpike", "LongSpikeToBlockOut", "LongSpikeToLine",
        "LongWaitSpike", "LucasServeToss", "LunarFlask", "Meow", "MetalBlood", "MiddleVerticalServeToss",
        "MiraculousToss", "Noon", "Noon_Des", "Noon_SunSetDes", "OasisServeToss", "OffensiveDirectToss",
        "OnepointPlayer", "OutOfBoundsSpike", "OutOfShape", "Overdrive", "Overdrive_SkinGodFather",
        "Parry_SkinHomunculus", "Parry_SkinWedding", "RaulFirstImpact", "RedHoodRyuhyunFirstImpact",
        "RyuhyunRedhoodFurstImpact", "SkyServeLisia_SkinRudolph", "ThunderSpike_HighSchool",
        "ThunderSpike_Original", "ThunderSpike_SkinBlack", "VerticalSpike", "VerticalSpikeJenny",
        "WhiteSpike", "Default"
    }

    local m = gg.choice({
        "📍Tambah Skill ke Favorit",
        "⭐ Lihat Daftar Favorit",
        "🗑️Hapus Semua Favorit",
        "Kembali"
    }, nil, "⭐ FAVORITE MENU")

    if not m or m == 4 then return menuUtama() end

    if m == 1 then
        local pick = gg.multiChoice(allSkillsList, nil, "Pilih Skill yang mau dijadikan Favorit:")
        if not pick then return menuFavoriteSkill() end

        local added = 0
        for i = 1, #allSkillsList do
            if pick[i] then
                local isDuplicate = false
                for _, fav in ipairs(favoriteSkills) do
                    if fav == allSkillsList[i] then
                        isDuplicate = true
                        break
                    end
                end
                
                if not isDuplicate then
                    table.insert(favoriteSkills, allSkillsList[i])
                    added = added + 1
                end
            end
        end
        
        if added > 0 then
            saveFavorite() -- Simpan ke file
            loadFavorite() -- Baca ulang biar memori sinkron sama file
            gg.alert("✅ Berhasil menambahkan "..added.." skill ke Favorit!")
        else
            gg.alert("⚠️ Skill yang dipilih sudah ada semua di Favorit!")
        end
        
    elseif m == 2 then
        if #favoriteSkills == 0 then
            gg.alert("❌ Daftar Favorit kamu masih kosong.")
        else
            local textFav = "⭐ DAFTAR FAVORIT KAMU:\n─────────────────\n"
            for i, skillName in ipairs(favoriteSkills) do
                textFav = textFav .. i .. ". " .. skillName .. "\n"
            end
            textFav = textFav .. "─────────────────\nTotal: " .. #favoriteSkills .. " skill"
            gg.alert(textFav)
        end
        
    elseif m == 3 then
        favoriteSkills = {}
        saveFavorite() 
        loadFavorite() -- Reset memori
        gg.alert("✅ Semua daftar favorit berhasil dihapus!")
    end
    
    menuFavoriteSkill()
end

-- ==========================================
-- SISTEM BACKUP & RESTORE SKILL (UPDATED)
-- ==========================================
function menuBackupSkill()
    gg.setVisible(false)
    
    local menu = gg.choice({
        "🛠️Restore Skill Tertentu",
        "🛠️Restore Semua ke Asli",
        "🗑️Bersihkan Riwayat Edit",
        "Kembali"
    }, nil, "RESTORE MENU")
    
    if not menu or menu == 4 then return gameplayMenu() end
    
    if menu == 1 then
        -- RESTORE PILIHAN
        if #editHistory == 0 then
            gg.alert("❌ Belum ada riwayat edit skill di sesi ini.\nLakukan edit dulu baru bisa restore.")
            return menuBackupSkill()
        end

        local historyMenu = {}
        for i, data in ipairs(editHistory) do
            historyMenu[#historyMenu + 1] = "["..data.char.."] "..data.oldName.." -> "..data.newName
        end

        local pick = gg.multiChoice(historyMenu, nil, "Pilih Skill yang mau di-Restore:")
        if not pick then return menuBackupSkill() end

        local restoreList = {}
        local count = 0
        for i = 1, #historyMenu do
            if pick[i] then
                local data = editHistory[i]
                for _, v in ipairs(data.originalBytes) do
                    restoreList[#restoreList + 1] = {
                        address = v.address,
                        flags = gg.TYPE_BYTE,
                        value = v.value
                    }
                end
                count = count + 1
            end
        end

        if #restoreList == 0 then
            gg.toast("Tidak ada yang dipilih.")
            return menuBackupSkill()
        end

        local ok = pcall(function() gg.setValues(restoreList) end)
        gg.clearResults()
        
        if ok then
            gg.alert("✅ Berhasil me-restore "..count.." skill ke bentuk aslinya!")
        else
            gg.alert("❌ Gagal me-restore.")
        end

    elseif menu == 2 then
        -- RESTORE SEMUA
        if #editHistory == 0 then
            gg.alert("❌ Belum ada riwayat edit skill di sesi ini.")
            return menuBackupSkill()
        end
        
        gg.toast("Mengembalikan semua skill...")
        
        local restoreList = {}
        for _, data in ipairs(editHistory) do
            for _, v in ipairs(data.originalBytes) do
                restoreList[#restoreList + 1] = {
                    address = v.address,
                    flags = gg.TYPE_BYTE,
                    value = v.value
                }
            end
        end
        
        local ok = pcall(function() gg.setValues(restoreList) end)
        gg.clearResults()
        
        if ok then
            gg.alert("✅ Berhasil me-restore SEMUA skill ke bentuk aslinya!")
            editHistory = {} -- Bersihin history setelah restore semua
        else
            gg.alert("❌ Gagal me-restore.")
        end

    elseif menu == 3 then
        -- BERSIHKAN HISTORY
        editHistory = {}
        gg.alert("✅ Riwayat edit berhasil dibersihkan!")
    end
    
    menuBackupSkill()
end
-- SPEED HACK
function speedHack()
    gg.setVisible(false)
    gg.toast("Mencari Speed Hack...")
    gg.clearResults()
    
    -- Pastikan pake memory range pilihan user
    if MEMORY_RANGE ~= nil then
        gg.setRanges(MEMORY_RANGE)
    else
        gg.setRanges(gg.REGION_C_ALLOC)
    end

    -- 1. Cari 116 (Double)
    gg.searchNumber("116", gg.TYPE_DOUBLE)
    local res1 = gg.getResults(100000)
    
    if #res1 == 0 then
        gg.alert("❌ Gagal: Nilai 116 tidak ditemukan!")
        return
    end

    -- 2. Offset +10 (0x10)
    local offset1 = {}
    for _, v in ipairs(res1) do 
        offset1[#offset1+1] = {address = v.address + 0x10, flags = gg.TYPE_DOUBLE} 
    end
    gg.loadResults(offset1)
    
    -- 3. Refine 1
    gg.refineNumber("1", gg.TYPE_DOUBLE)
    local res2 = gg.getResults(100000)
    
    if #res2 == 0 then
        gg.alert("❌ Gagal: Refine nilai 1 tidak ditemukan!")
        return
    end

    -- 4. Offset +30 (0x30)
    local offset2 = {}
    for _, v in ipairs(res2) do 
        offset2[#offset2+1] = {address = v.address + 0x30, flags = gg.TYPE_DOUBLE} 
    end
    gg.loadResults(offset2)
    
    -- 5. Cari 60
    gg.searchNumber("60", gg.TYPE_DOUBLE)
    local resFinal = gg.getResults(100000)
    
    if #resFinal == 0 then
        gg.alert("❌ Gagal: Nilai 60 tidak ditemukan!")
        return
    end

    -- 6. Edit jadi 20
    local editList = {}
    for _, v in ipairs(resFinal) do
        if v.address and v.address ~= 0 then
            editList[#editList + 1] = {address = v.address, flags = gg.TYPE_DOUBLE, value = 20}
        end
    end
    
    local ok = pcall(function() gg.setValues(editList) end)
    gg.clearResults()
    
    if ok then
        gg.alert("✅ Speed Hack Berhasil Diaktifkan!")
    else
        gg.alert("❌ Gagal mengedit nilai Speed Hack!")
    end
end

-- ==========================================
-- VOLLEYBALL SKIN & BACKGROUND MENU (KATEGORI)
-- Search base: 91 -> -0x10 -> refine 115
-- Offset bola: -0x610 (hex -610), BG: -0x230 (hex -230)
-- ==========================================
local savedBallAddress = nil
local savedBgAddress = nil

local function searchSkinBase()
    gg.clearResults()
    local range = (MEMORY_RANGE or gg.REGION_C_ALLOC) | gg.REGION_ANONYMOUS
    gg.setRanges(range)
    gg.toast("Mencari base address...")
    gg.searchNumber("91", gg.TYPE_DOUBLE)
    local count = gg.getResultCount()
    if count == 0 then
        gg.clearResults()
        return nil
    end

    local raw = gg.getResults(count)
    local shifted = {}
    for i, r in ipairs(raw) do
        shifted[i] = { address = r.address - 0x10, flags = gg.TYPE_DOUBLE }
    end

    gg.loadResults(shifted)
    gg.refineNumber("115", gg.TYPE_DOUBLE)
    local refinedCount = gg.getResultCount()
    if refinedCount == 0 then
        gg.clearResults()
        return nil
    end

    local refined = gg.getResults(refinedCount)
    local base = refined[refinedCount].address
    gg.clearResults()
    return base
end

local function applySkinValue(offsetHex, value, category)
    local target = (category == "ball") and savedBallAddress or savedBgAddress
    if target == nil then
        local base = searchSkinBase()
        if base == nil then return false end
        local off = tonumber(offsetHex, 16)
        if not off then return false end
        target = base + off
        if category == "ball" then savedBallAddress = target
        else savedBgAddress = target end
    end

    local ok = pcall(function()
        gg.setValues({{ address = target, flags = gg.TYPE_DOUBLE, value = value, freeze = true }})
        gg.addListItems({{ address = target, flags = gg.TYPE_DOUBLE, value = value, freeze = true }})
    end)
    return ok
end

-- Bola dikelompokin per tema: {nama, id}
local BALL_THEMES = {
    { name = "Basic", items = {
        {"Beach Ball", 0}, {"Watermelon Beach Ball", 1}, {"Full Moon", 3}, {"High Noon", 4}
    }},
    { name = "Event", items = {
        {"Piggy Bank Ball", 5}, {"Crimson Valentia Ball", 6}, {"Trick Ball", 7},
        {"Pinata Ball", 8}, {"Bouquet Volleyball", 9}, {"Rise Volleyball", 10},
        {"Master Ball", 13}, {"2026 Lucky Pouch Ball", 26}, {"8th Anniversary Commemorative Ball", 30}
    }},
    { name = "Seasonal", items = {
        {"Christmas Ball", 11}, {"Winter Snow Ball", 12}, {"Star Snow Ball", 23},
        {"Jingle Bell Ball", 22}, {"Jack o lantern Ball", 19}, {"Mother of pearl Ball", 25}
    }},
    { name = "Prestige", items = {
        {"Nishikawa Ball", 2}, {"Ball Nishikawa Black", 24}, {"Seonrim High School Ball", 14},
        {"Seaweed Ball", 15}, {"Silver Balloon Ball", 16}, {"Blue Balloon Ball", 17},
        {"Black Spider Ball", 18}, {"Ball Neon", 20}, {"Ball Venom", 21},
        {"Graffiti King", 27}, {"Wind Spiral Ball", 28}, {"Prism Rainbow Ball", 29},
        {"Mystic Aurora Ball", 31}, {"Tumbleweed Ball", 32}, {"Cactus Ball", 33}
    }}
}

local BG_TYPES = {
    { name = "Tournament", items = {
        {"Regional Tournament Arena", 0}, {"National Tournament Arena", 2},
        {"Superstar Challenge", 6}, {"Volleyball Colosseum", 9},
        {"Valentia Spikes Court", 7}, {"Valentia Spikes Court 2", 8},
        {"Azure Dragon Festival", 15}
    }},
    { name = "School", items = {
        {"School Gym", 3}, {"Seonrim High", 10}, {"School Garden", 21}, {"Chromakey", 18}
    }},
    { name = "Seasonal", items = {
        {"Summer Splash", 4}, {"Rockwell Winter Camp", 11}, {"Rockwell Winter Camp Gym", 12}
    }},
    { name = "Special", items = {
        {"Unknown Arena 1", 1}, {"Unknown Arena 2", 5}, {"Dark City", 13},
        {"Phantom League", 14}, {"Phantom League (Old)", 16}, {"Nightmare Arena", 17},
        {"Phantom League Performance Hall", 19}, {"Outlaw Frontier", 20}
    }}
}

local function pickFromTheme(themes, title, offsetHex, category, label)
    -- level 1: pilih tema
    local themeMenu = {}
    for i, t in ipairs(themes) do themeMenu[i] = "    ▸  " .. t.name end
    themeMenu[#themeMenu + 1] = "    ▸  Kembali"
    local tChoice = gg.choice(themeMenu, nil, title .. " — Pilih Kategori")
    if not tChoice or tChoice == #themeMenu then return false end

    -- level 2: pilih item dalam tema
    local theme = themes[tChoice]
    local itemMenu = {}
    for i, it in ipairs(theme.items) do itemMenu[i] = "    ▸  " .. it[1] end
    itemMenu[#itemMenu + 1] = "    ▸  Kembali"
    local iChoice = gg.choice(itemMenu, nil, title .. " › " .. theme.name)
    if not iChoice or iChoice == #itemMenu then return false end

    local picked = theme.items[iChoice]
    local ok = applySkinValue(offsetHex, picked[2], category)
    if not ok then
        gg.alert("📄 not found ❌\n─────────────────\nGagal menerapkan " .. label .. "!\nBase address tidak ditemukan.\n─────────────────")
        return false
    end
    gg.alert("📄 success/done ✅\n─────────────────\n" .. label .. " berhasil diubah jadi:\n" .. picked[1] .. "\n─────────────────")
    return true
end

function menuVolleyballSkin()
    gg.setVisible(false)
    while true do
        local ok = pickFromTheme(BALL_THEMES, "🏐 VOLLEYBALL SKIN", "-610", "ball", "Volleyball Skin")
        if not ok then return end
    end
end

function menuBackgroundSkin()
    gg.setVisible(false)
    while true do
        local ok = pickFromTheme(BG_TYPES, "🖼️ BACKGROUND IN GAME", "-230", "bg", "Background")
        if not ok then return end
    end
end

-- ==========================================
-- UNLIMITED SKILL (SANGHYEON) - DUAL MEMORY (Ca + Other)
-- ==========================================
function unlimitedSkillSangHyeon()
    gg.setVisible(false)
    gg.clearResults()
    gg.toast("Mencari Unlimited Skill Sanghyeon (Ca + Other)...")

    -- Set Memory ke Ca + Other secara eksklusif buat fungsi ini
    gg.setRanges(gg.REGION_C_ALLOC | gg.REGION_OTHER)

    -- 1. Cari nilai 300 (Double)
    gg.searchNumber("300", gg.TYPE_DOUBLE)
    local res1 = gg.getResults(100000)
    if #res1 == 0 then
        gg.alert("❌ Gagal: Nilai 300 tidak ditemukan di memory Ca maupun Other!\nPastikan Sanghyeon ada di tim.")
        return false
    end

    -- 2. Offset +0x10, cari 2100
    local off1 = {}
    for _, v in ipairs(res1) do off1[#off1 + 1] = {address = v.address + 0x10, flags = gg.TYPE_DOUBLE} end
    gg.clearResults()
    gg.loadResults(off1)
    gg.searchNumber("2100", gg.TYPE_DOUBLE)
    local res2 = gg.getResults(100000)
    if #res2 == 0 then
        gg.alert("❌ Gagal: 2100 tidak ditemukan di offset +10!")
        return false
    end

    -- 3. Offset +0x10, cari 1800
    local off2 = {}
    for _, v in ipairs(res2) do off2[#off2 + 1] = {address = v.address + 0x10, flags = gg.TYPE_DOUBLE} end
    gg.clearResults()
    gg.loadResults(off2)
    gg.searchNumber("1800", gg.TYPE_DOUBLE)
    local res3 = gg.getResults(100000)
    if #res3 == 0 then
        gg.alert("❌ Gagal: 1800 tidak ditemukan di offset +10!")
        return false
    end

    -- 4. Offset +0x10, cari 360
    local off3 = {}
    for _, v in ipairs(res3) do off3[#off3 + 1] = {address = v.address + 0x10, flags = gg.TYPE_DOUBLE} end
    gg.clearResults()
    gg.loadResults(off3)
    gg.searchNumber("360", gg.TYPE_DOUBLE)
    local res4 = gg.getResults(100000)
    if #res4 == 0 then
        gg.alert("❌ Gagal: 360 tidak ditemukan di offset +10!")
        return false
    end

    -- 5. Offset -0x30, cari 300 (buat dapet base address paling awal)
    local off4 = {}
    for _, v in ipairs(res4) do off4[#off4 + 1] = {address = v.address - 0x30, flags = gg.TYPE_DOUBLE} end
    gg.clearResults()
    gg.loadResults(off4)
    gg.searchNumber("300", gg.TYPE_DOUBLE)
    local resFinal = gg.getResults(100000)
    if #resFinal == 0 then
        gg.alert("❌ Gagal: Gagal kembali ke 300 di offset -30!")
        return false
    end

    -- 6. Tembak semua stat jadi 99999999
    local editList = {}
    for _, v in ipairs(resFinal) do
        if v.address and v.address ~= 0 then
            local base = v.address
            editList[#editList + 1] = {address = base, flags = gg.TYPE_DOUBLE, value = 99999999}
            editList[#editList + 1] = {address = base + 0x10, flags = gg.TYPE_DOUBLE, value = 99999999}
            editList[#editList + 1] = {address = base + 0x20, flags = gg.TYPE_DOUBLE, value = 99999999}
            editList[#editList + 1] = {address = base + 0x30, flags = gg.TYPE_DOUBLE, value = 99999999}
        end
    end

    if #editList == 0 then
        gg.alert("❌ Gagal: Tidak ada address valid untuk diedit.")
        return false
    end

    local ok = pcall(function() gg.setValues(editList) end)
    gg.clearResults()

    -- Balikin setting memory ke pilihan awal user (Ca atau Other)
    if MEMORY_RANGE ~= nil then
        gg.setRanges(MEMORY_RANGE)
    end

    if ok then
        gg.alert("📄 Success/done ✅\n─────────────────\nUnlimited Skill Sanghyeon Aktif!\n─────────────────")
        return true
    else
        gg.alert("❌ Gagal mengedit memory!")
        return false
    end
end

-- ==========================================
-- SISTEM EDIT CHARACTER
-- ==========================================
function menuEditCharacter()
    gg.setVisible(false)
    local inputCount = gg.prompt({"Masukkan jumlah karakter yang lu punya:"}, {"10"}, {"number"})
    if not inputCount or not inputCount[1] then return end
    
    local charCount = tonumber(inputCount[1])
    if not charCount or charCount <= 0 then
        gg.alert("Jumlah tidak valid!")
        return menuUtama()
    end

    gg.clearResults()
    gg.setRanges(MEMORY_RANGE)
    gg.toast("Mencari alamat dasar karakter...")

    -- 1. Cari Base Address (Ambil SEMUA hasil)
    gg.searchNumber("206398", gg.TYPE_DOUBLE)
    local res1 = gg.getResults(100000)
    if #res1 == 0 then
        gg.alert("Gagal: Base address tidak ditemukan!")
        return menuUtama()
    end

    -- 2. Geser SEMUA hasil ke -0x10 (Anti Gagal Refine)
    local shiftedResults = {}
    for i, v in ipairs(res1) do
        shiftedResults[#shiftedResults + 1] = {
            address = v.address - 0x10, 
            flags = gg.TYPE_DOUBLE
        }
    end
    
    gg.clearResults()
    gg.loadResults(shiftedResults)

    -- 3. Refine angka 226618
    gg.refineNumber("226618", gg.TYPE_DOUBLE)
    local res2 = gg.getResults(100000)
    if #res2 == 0 then
        gg.alert("Gagal: Refine tidak ditemukan!")
        return menuUtama()
    end

    local finalBase = res2[1].address - 0x1C0

    -- 4. Scan karakter
    local scanList = {}
    for i = 0, charCount - 1 do
        local addr = finalBase - (i * 0x150)
        scanList[#scanList + 1] = {address = addr, flags = gg.TYPE_DOUBLE}
    end

    gg.loadResults(scanList)
    local values = gg.getValues(scanList)
    
    local charMenu = {}
    local charAddrMap = {}

    for i, v in ipairs(values) do
        local id = v.value
        local name = characterList[id] or ("Unknown ID: " .. tostring(id))
        charMenu[#charMenu + 1] = name
        charAddrMap[#charAddrMap + 1] = v.address
    end

    if #charMenu == 0 then
        gg.alert("Tidak ada karakter yang terdeteksi!")
        return menuUtama()
    end

    -- 5. Multi Choice
    local choices = gg.multiChoice(charMenu, nil, "Pilih Karakter ASAL yang mau diedit")
    if not choices then return menuUtama() end

    local selectedIndices = {}
    for i = 1, #charMenu do
        if choices[i] then
            table.insert(selectedIndices, i)
        end
    end

    if #selectedIndices == 0 then
        gg.alert("Tidak ada karakter yang dipilih!")
        return menuEditCharacter()
    end

    -- 6. Pilih Mode Edit
    local editMode = gg.choice({"Edit Stats Saja", "Edit Stats + Karakter", "Kembali"}, nil, "Pilih Mode Edit")
    if not editMode or editMode == 3 then return menuEditCharacter() end

    local targetCharId = nil
    local newSkin = nil

    -- 7. Kalau pilih Edit Stats + Karakter
    if editMode == 2 then
        local posMenu = gg.choice({"Wing Spiker (WS)", "Middle Blocker (MB)", "Setter (SE)", "Kembali"}, nil, "Pilih Posisi Karakter Tujuan")
        if not posMenu or posMenu == 4 then return menuEditCharacter() end

        local charListMenu = {}
        local charIdList = {}

        if posMenu == 1 then
            charListMenu = {
                "Nishikawa", "Nishikawa Old", "Nishikawa?", "Raul Luca", "Raul Luca Dark Mode", "Siwoo Storm",
                "Siwoo Highlight", "Isabel", "Lucas", "Ryuhyun", "Sara WS", "Leon", "Jenny", "Hongsi",
                "Oasis", "Yoonseok", "Minjun", "Jaehyeon", "Youngsup", "Dave", "Seo Yuna"
            }
            charIdList = {
                "98", "99", "164", "324", "352", "296",
                "325", "159", "284", "225", "351", "158", "251", "212",
                "50", "39", "65", "30", "10", "228", "388"
            }
        elseif posMenu == 2 then
            charListMenu = {
                "Heesung", "Roberto", "Atis", "Yamadera", "Sanghyeon", "Hanra", "Mike",
                "Clyde", "Hari", "Crow", "Claire", "Yuri", "Han Gitae"
            }
            charIdList = {
                "19", "163", "44", "96", "160", "218", "229",
                "232", "282", "283", "322", "350", "387"
            }
        elseif posMenu == 3 then
            charListMenu = {
                "Seolhwa", "NN", "Viola", "Sohee", "Ahyeon", "Lisia", "Muyoung",
                "Sodam", "Sara SE", "Tania", "Ellio", "Zero", "Sif", "Iris", "Jihoon"
            }
            charIdList = {
                "200", "161", "157", "95", "31", "40", "221",
                "215", "230", "231", "252", "286", "323", "349", "375"
            }
        end

        local pickChar = gg.choice(charListMenu, nil, "Ubah Karakter Menjadi:")
        if not pickChar then return menuEditCharacter() end
        targetCharId = charIdList[pickChar]

        local skinInfo = 
            "Daftar ID Skin:\n" ..
            "1: Nishikawa+High School\n" .. "4: Nishikawa+Black Thunder\n" ..
            "7: Ryuhyeon+Chief Disciple\n" .. "19: Ryuhyeon+Red Hood\n" ..
            "22: Lucas+Summer Training\n" .. "8: Sara SE+Water Splash\n" ..
            "16: Ellio+Star of the Encore\n" .. "5: Ahyeon+Style\n" ..
            "12: Sohee+Vampire\n" .. "11: NN+Surfer\n" ..
            "13: Lisia+Rudolph\n" .. "21: Claire+God Father\n" ..
            "23: Hanra+Summer Training\n" .. "18: Hari+Midnight\n" ..
            "3: Jaehyeon+Training\n" .. "17: Jenny+Shooting Star\n" ..
            "9: Jenny+Straw Hat\n" .. "2: Isabel+Wedding Dress\n" ..
            "10: Dave+Driver\n" .. "14: Hongshi+Maid\n" ..
            "15: Zero+Street Artist\n" .. "20: Sif+Bounty Hunter\n" ..
            "24: Viola+Summer Training\n" .. "25: Tania+Homunculus\n" ..
            "26: Isabel+Homunculus\n" .. "(-1: Default)"

        local pSkin = gg.prompt({"Masukkan ID Skin (Kosongkan untuk skip):\n\n" .. skinInfo}, {"-1"}, {"number"})
        if pSkin and pSkin[1] and tostring(pSkin[1]):match("^%s*$") == nil then
            newSkin = tonumber(pSkin[1])
        end
    end

    -- 8. Input Stats
    local pStats = gg.prompt(
        {"Masukkan nilai Attack:", "Masukkan nilai Defense:", "Masukkan nilai Speed:", "Masukkan nilai Jump:", "Masukkan nilai Ascencion:"},
        {"200", "300", "50", "200", "5"},
        {"number", "number", "number", "number", "number"}
    )
    local newAttack, newDefense, newSpeed, newJump, newAsc = nil, nil, nil, nil, nil
    if pStats then
        newAttack = tonumber(pStats[1])
        newDefense = tonumber(pStats[2])
        newSpeed = tonumber(pStats[3])
        newJump = tonumber(pStats[4])
        newAsc = tonumber(pStats[5])
    end

    -- 9. EKSEKUSI EDIT (PAKE OFFSET BARU)
    local editList = {}
    for _, idx in ipairs(selectedIndices) do
        local addr = charAddrMap[idx]
        
        -- Edit ID Karakter
        if targetCharId then
            editList[#editList + 1] = {address = addr, flags = gg.TYPE_DOUBLE, value = targetCharId}
        end
        
        -- Edit Skin
        if newSkin ~= nil then
            editList[#editList + 1] = {address = addr + 0x120, flags = gg.TYPE_DOUBLE, value = newSkin}
        end

        -- Edit Stats (OFFSET BARU)
        if newAttack then
            editList[#editList + 1] = {address = addr + 0xB0, flags = gg.TYPE_DOUBLE, value = newAttack}
            editList[#editList + 1] = {address = addr + 0xF0, flags = gg.TYPE_DOUBLE, value = newDefense}
            editList[#editList + 1] = {address = addr + 0x20, flags = gg.TYPE_DOUBLE, value = newSpeed}
            editList[#editList + 1] = {address = addr + 0x60, flags = gg.TYPE_DOUBLE, value = newJump}
            editList[#editList + 1] = {address = addr + 0xA0, flags = gg.TYPE_DOUBLE, value = newAsc}
        end
    end

    local ok = pcall(function() gg.setValues(editList) end)
    gg.clearResults()

    if ok then
        gg.alert("✅ Edit Karakter Berhasil!")
    else
        gg.alert("❌ Gagal mengedit! Cek logika offset lu.")
    end

    menuUtama()
end

-- ==========================================
-- SISTEM MASTERY BARU
-- ==========================================
function prosesMastery(namaMasteryAwal)
    gg.setVisible(false)
    
    -- 1. Pilih Posisi Karakter
    local posMenu = gg.choice({"Wing Spiker (WS)", "Middle Blocker (MB)", "Setter (SE)", "Kembali"}, nil, "Pilih Posisi Karakter")
    if not posMenu or posMenu == 4 then return masteryMenu() end

    local charListMenu = {}
    local charIdList = {}

    if posMenu == 1 then
        charListMenu = {
            "Nishikawa", "Nishikawa Old", "Nishikawa?", "Raul Luca", "Raul Luca Dark Mode", "Siwoo Storm",
            "Siwoo Highlight", "Isabel", "Lucas", "Ryuhyun", "Sara WS", "Leon", "Jenny", "Hongsi",
            "Oasis", "Yoonseok", "Minjun", "Jaehyeon", "Youngsup", "Dave", "Seo Yuna"
        }
        charIdList = {
            "98", "99", "164", "324", "352", "296",
            "325", "159", "284", "225", "351", "158", "251", "212",
            "50", "39", "65", "30", "10", "228", "388"
        }
    elseif posMenu == 2 then
        charListMenu = {
            "Heesung", "Roberto", "Atis", "Yamadera", "Sanghyeon", "Hanra", "Mike",
            "Clyde", "Hari", "Crow", "Claire", "Yuri", "Han Gitae"
        }
        charIdList = {
            "19", "163", "44", "96", "160", "218", "229",
            "232", "282", "283", "322", "350", "387"
        }
    elseif posMenu == 3 then
        charListMenu = {
            "Seolhwa", "NN", "Viola", "Sohee", "Ahyeon", "Lisia", "Muyoung",
            "Sodam", "Sara SE", "Tania", "Ellio", "Zero", "Sif", "Iris", "Jihoon"
        }
        charIdList = {
            "200", "161", "157", "95", "31", "40", "221",
            "215", "230", "231", "252", "286", "323", "349", "375"
        }
    end

    local pickChar = gg.choice(charListMenu, nil, "Pilih Karakter untuk Mastery:")
    if not pickChar then return masteryMenu() end
    local targetCharId = charIdList[pickChar]
    local targetCharName = charListMenu[pickChar]

    gg.clearResults()
    gg.setRanges(MEMORY_RANGE)
    gg.toast("Mencari ID " .. targetCharName .. "...")

    -- 2. Cari ID Karakter
    gg.searchNumber(targetCharId, gg.TYPE_DOUBLE)
    local resChar = gg.getResults(100000)
    if #resChar == 0 then
        gg.alert("❌ Gagal: ID " .. targetCharName .. " tidak ditemukan!")
        return masteryMenu()
    end

    -- 3. Offset +0x20 -> Cari ID Mastery
    local off1 = {}
    for _, v in ipairs(resChar) do off1[#off1+1] = {address = v.address + 0x20, flags = gg.TYPE_DOUBLE} end
    gg.loadResults(off1)
    
    gg.searchNumber(namaMasteryAwal, gg.TYPE_DOUBLE)
    local resMastery = gg.getResults(100000)
    if #resMastery == 0 then
        gg.alert("❌ Gagal: Mastery awal tidak ditemukan di offset +20!")
        return masteryMenu()
    end

    -- 4. Offset +0x20 -> Cari ID Mastery Lagi
    local off2 = {}
    for _, v in ipairs(resMastery) do off2[#off2+1] = {address = v.address - 0x40, flags = gg.TYPE_DOUBLE} end
    gg.loadResults(off2)

    gg.searchNumber(namaMasteryAwal, gg.TYPE_DOUBLE)
    local resFinal = gg.getResults(100000)
    if #resFinal == 0 then
        gg.alert("❌ Gagal: Mastery tidak ditemukan di offset +20 kedua!")
        return masteryMenu()
    end
    
    gg.clearResults()

    -- 5. Pilih Mastery Baru
    local mMastery = gg.choice({"Veteran (1)", "Elite (2)", "Legend (3)", "Champion (4)", "Kembali"}, nil, "Pilih Mastery Baru:")
    if not mMastery or mMastery == 5 then return masteryMenu() end

    local newMasteryVal = mMastery -- Veteran = 1, Elite = 2, dst.

    -- 6. Eksekusi Edit
    local editList = {}
    for _, v in ipairs(resFinal) do
        if v.address and v.address ~= 0 then
            editList[#editList + 1] = {address = v.address, flags = gg.TYPE_DOUBLE, value = newMasteryVal}
        end
    end

    local ok = pcall(function() gg.setValues(editList) end)
    gg.clearResults()

    if ok then
        gg.alert("✅ Mastery " .. targetCharName .. " Berhasil Diubah!")
    else
        gg.alert("❌ Gagal mengedit Mastery!")
    end

    masteryMenu()
end

--Mastery Menu
function masteryMenu()
    gg.setVisible(false)
    local menuTitle = "Menu Mastery [" .. tostring(USER_NAME) .. "] - " .. tostring(MEMORY_NAME)

    local menu = gg.choice({
    	"Veteran",
        "Elite",
        "Legend",
        "Return",
    }, nil, menuTitle)
    
    if menu == 1 then
        prosesMastery("1") -- Cari yang Veteran
    elseif menu == 2 then
        prosesMastery("2") -- Cari yang Elite
    elseif menu == 3 then
        prosesMastery("3") -- Cari yang Legend
    elseif menu == 4 then
        menuUtama()
    end
end

-- ==========================================
-- QUICK SCAN CHARACTER (METODE -1 OFFSET)
-- ==========================================
function quickScanChar(targetPosName)
    gg.setVisible(false)
    
    local originID = "1"
    if targetPosName == "Ohjun" then originID = "3"
    elseif targetPosName == "Jaeho" then originID = "2" end

    gg.clearResults()
    gg.setRanges(MEMORY_RANGE)
    gg.toast("Mencari ID " .. targetPosName .. "...")

    gg.searchNumber("-1", gg.TYPE_DOUBLE)
    local res1 = gg.getResults(100000)
    if #res1 == 0 then
        gg.alert("❌ Gagal: Nilai -1 tidak ditemukan!")
        return charMenu()
    end

    -- Geser SEMUA hasil ke -0x30
    local off1 = {}
    for _, v in ipairs(res1) do 
        off1[#off1+1] = {address = v.address - 0x20, flags = gg.TYPE_DOUBLE} 
    end
    gg.loadResults(off1)

    gg.refineNumber("-1", gg.TYPE_DOUBLE)
    local res2 = gg.getResults(100000)
    if #res2 == 0 then
        gg.alert("❌ Gagal: Refine -1 pertama gagal!")
        return charMenu()
    end

    -- Geser SEMUA hasil ke -0x20
    local off2 = {}
    for _, v in ipairs(res2) do 
        off2[#off2+1] = {address = v.address - 0x20, flags = gg.TYPE_DOUBLE} 
    end
    gg.loadResults(off2)

    gg.refineNumber("-1", gg.TYPE_DOUBLE)
    local res3 = gg.getResults(100000)
    if #res3 == 0 then
        gg.alert("❌ Gagal: Refine -1 kedua gagal!")
        return charMenu()
    end

    -- Geser SEMUA hasil ke +0x40
    local off3 = {}
    for _, v in ipairs(res3) do 
        off3[#off3+1] = {address = v.address + 0x30, flags = gg.TYPE_DOUBLE} 
    end
    gg.loadResults(off3)

    -- Cari ID Karakter dari titik ini
    gg.searchNumber(originID, gg.TYPE_DOUBLE)
    local resFinal = gg.getResults(100000)
    
    if #resFinal == 0 then
        gg.alert("❌ Gagal: ID " .. targetPosName .. " (" .. originID .. ") tidak ditemukan!")
        gg.clearResults()
        return charMenu()
    end

    local targetAddr = resFinal[1].address
    gg.clearResults()

    local posMenu = gg.choice({"Wing Spiker (WS)", "Middle Blocker (MB)", "Setter (SE)", "Kembali"}, nil, "Pilih Posisi Karakter Tujuan")
    if not posMenu or posMenu == 4 then return charMenu() end

    local charListMenu = {}
    local charIdList = {}

    if posMenu == 1 then
        charListMenu = {
            "Nishikawa", "Nishikawa Old", "Nishikawa?", "Raul Luca", "Raul Luca Dark Mode", "Siwoo Storm",
            "Siwoo Highlight", "Isabel", "Lucas", "Ryuhyun", "Sara WS", "Leon", "Jenny", "Hongsi",
            "Oasis", "Yoonseok", "Minjun", "Jaehyeon", "Youngsup", "Dave", "Seo Yuna"
        }
        charIdList = {
            "98", "99", "164", "324", "352", "296",
            "325", "159", "284", "225", "351", "158", "251", "212",
            "50", "39", "65", "30", "10", "228", "388"
        }
    elseif posMenu == 2 then
        charListMenu = {
            "Heesung", "Roberto", "Atis", "Yamadera", "Sanghyeon", "Hanra", "Mike",
            "Clyde", "Hari", "Crow", "Claire", "Yuri", "Han Gitae"
        }
        charIdList = {
            "19", "163", "44", "96", "160", "218", "229",
            "232", "282", "283", "322", "350", "387"
        }
    elseif posMenu == 3 then
        charListMenu = {
            "Seolhwa", "NN", "Viola", "Sohee", "Ahyeon", "Lisia", "Muyoung",
            "Sodam", "Sara SE", "Tania", "Ellio", "Zero", "Sif", "Iris", "Jihoon"
        }
        charIdList = {
            "200", "161", "157", "95", "31", "40", "221",
            "215", "230", "231", "252", "286", "323", "349", "375"
        }
    end

    local pickChar = gg.choice(charListMenu, nil, "Ubah Karakter Menjadi:")
    if not pickChar then return charMenu() end
    local targetCharId = charIdList[pickChar]

    local skinInfo = 
        "Daftar ID Skin:\n" ..
        "1: Nishikawa+High School\n" .. "4: Nishikawa+Black Thunder\n" ..
        "7: Ryuhyeon+Chief Disciple\n" .. "19: Ryuhyeon+Red Hood\n" ..
        "22: Lucas+Summer Training\n" .. "8: Sara SE+Water Splash\n" ..
        "16: Ellio+Star of the Encore\n" .. "5: Ahyeon+Style\n" ..
        "12: Sohee+Vampire\n" .. "11: NN+Surfer\n" ..
        "13: Lisia+Rudolph\n" .. "21: Claire+God Father\n" ..
        "23: Hanra+Summer Training\n" .. "18: Hari+Midnight\n" ..
        "3: Jaehyeon+Training\n" .. "17: Jenny+Shooting Star\n" ..
        "9: Jenny+Straw Hat\n" .. "2: Isabel+Wedding Dress\n" ..
        "10: Dave+Driver\n" .. "14: Hongshi+Maid\n" ..
        "15: Zero+Street Artist\n" .. "20: Sif+Bounty Hunter\n" ..
        "24: Viola+Summer Training\n" .. "25: Tania+Homunculus\n" ..
        "26: Isabel+Homunculus\n" .. "(-1: Default)"

    local pSkin = gg.prompt({"Masukkan ID Skin (Kosongkan untuk skip):\n\n" .. skinInfo}, {"-1"}, {"number"})
    local newSkin = nil
    if pSkin and pSkin[1] and tostring(pSkin[1]):match("^%s*$") == nil then
        newSkin = tonumber(pSkin[1])
    end

    local pStats = gg.prompt(
        {"Masukkan nilai Attack:", "Masukkan nilai Defense:", "Masukkan nilai Speed:", "Masukkan nilai Jump:", "Masukkan nilai Ascencion:"},
        {"200", "300", "50", "200", "5"},
        {"number", "number", "number", "number", "number"}
    )
    local newAttack, newDefense, newSpeed, newJump, newAsc = nil, nil, nil, nil, nil
    if pStats then
        newAttack = tonumber(pStats[1])
        newDefense = tonumber(pStats[2])
        newSpeed = tonumber(pStats[3])
        newJump = tonumber(pStats[4])
        newAsc = tonumber(pStats[5])
    end

    -- EKSEKUSI EDIT PAKE OFFSET BARU
    local editList = {}
    
    if targetCharId then
        editList[#editList + 1] = {address = targetAddr, flags = gg.TYPE_DOUBLE, value = targetCharId}
    end
    if newSkin ~= nil then
        editList[#editList + 1] = {address = targetAddr + 0x120, flags = gg.TYPE_DOUBLE, value = newSkin}
    end
    if newAttack then
        editList[#editList + 1] = {address = targetAddr + 0xB0, flags = gg.TYPE_DOUBLE, value = newAttack}
        editList[#editList + 1] = {address = targetAddr + 0xF0, flags = gg.TYPE_DOUBLE, value = newDefense}
        editList[#editList + 1] = {address = targetAddr + 0x20, flags = gg.TYPE_DOUBLE, value = newSpeed}
        editList[#editList + 1] = {address = targetAddr + 0x60, flags = gg.TYPE_DOUBLE, value = newJump}
        editList[#editList + 1] = {address = targetAddr + 0xA0, flags = gg.TYPE_DOUBLE, value = newAsc}
    end

    local ok = pcall(function() gg.setValues(editList) end)
    gg.clearResults()

    if ok then
        gg.alert("✅ Berhasil Mengubah Karakter " .. targetPosName .. "!")
    else
        gg.alert("❌ Gagal mengedit!")
    end

    charMenu()
end

-- ==========================================
-- EDIT CHARACTER V2 (SCAN BERDASARKAN NAMA HEX)
-- ==========================================
function menuEditCharV2()
    gg.setVisible(false)
    
    -- Tanya mau edit karakter siapa
    local charV2Menu = gg.choice({
        "Isabel",
        "Nishikawa Highschool",
        "Kembali"
    }, nil, "👑 Edit Character V2\nPilih Nama Karakter (Asal):")
    
    if not charV2Menu or charV2Menu == 3 then return menuUtama() end
    
    local searchHex = ""
    local namaKarakter = ""
    
    if charV2Menu == 1 then
        searchHex = "h49 73 61 62 65 6C 00 22"
        namaKarakter = "Isabel"
    elseif charV2Menu == 2 then
        searchHex = "h4E 69 73 68 69 6B 61 77 61 5F 53 6B 69 6E 48 69 67 68 73 73 63 68 6F 6F 6C 00 00"
        namaKarakter = "Nishikawa Highschool"
    end
    
    gg.clearResults()
    gg.setRanges(MEMORY_RANGE)
    gg.toast("Mencari " .. namaKarakter .. "...")
    
    -- Cari Hex nama karakter
    gg.searchNumber(searchHex, gg.TYPE_BYTE)
    local res = gg.getResults(100000)
    
    if #res == 0 then
        gg.alert("❌ Gagal: Nama " .. namaKarakter .. " tidak ditemukan di memory!")
        return menuEditCharV2()
    end
    
    local foundAddress = res[1].address
    gg.clearResults()
    gg.toast("Ketemu: " .. namaKarakter)
    gg.sleep(500)
    
    -- Tanya mau ubah jadi apa (List Normal / Favorit)
    local pilihanMode = gg.choice({
        "Nishikawa Highschool",
        "Raul",
        "Batal"
    }, nil, "Karakter Ditemukan!\nMau ubah jadi apa?")
    
    if not pilihanMode or pilihanMode == 2 then return menuUtama() end
    
    local hexBaru = ""
    local targetName = ""
    
    if pilihanMode == 1 then
        -- Target Nishikawa Highschool
        hexBaru = "4E 69 73 68 69 6B 61 77 61 5F 53 6B 69 6E 48 69 67 68 73 63 68 6F 6F 6C 00"
        targetName = "Nishikawa Highschool"
    elseif pilihanMode == 2 then
        hexBaru = "52 61 75 6C 00"
        targetName = "Raul"
    end
    
    -- Eksekusi edit (timpa teks nama lama dengan nama baru)
    local editList = {}
    local urutan = hexToDecimalTable(hexBaru)
    
    -- Karena string target lebih panjang (26 byte vs 8 byte Isabel), ini akan menimpa teks setelahnya.
    -- Pastikan alamat memory-nya cukup panjang biar ga crash.
    for i = 1, #urutan do
        editList[#editList + 1] = {
            address = foundAddress + (i - 1),
            flags = gg.TYPE_BYTE,
            value = urutan[i]
        }
    end
    
    local ok = pcall(function() gg.setValues(editList) end)
    gg.clearResults()
    
    if ok then
        gg.alert("✅ Berhasil Mengubah Karakter\n" .. namaKarakter .. " -> " .. targetName)
    else
        gg.alert("❌ Gagal mengedit memory!")
    end
    
    menuEditCharV2()
end

-- ==========================================
-- 1X INJECT ALL CHARACTER (FULL MESIN)
-- ==========================================
local POS_WS = {
    [98]="Nishikawa",[296]="Siwo storm",[325]="Siwo Highlight",[164]="Nishikawa?",[99]="Nishikawa old",
    [324]="Raul Luca",[352]="Raul Luca (Drak mode)",[351]="Sara WS",[50]="Oasis",[162]="Oasis Old",
    [212]="Hongshi",[228]="Dave",[159]="Isabel",[30]="Jaehyeon",[251]="Jenny",[10]="Young Sup",
    [336]="Young sub",[39]="Yunseok",[65]="Minjun",[158]="Leon",[199]="DUMMY",[79]="Kwangin",
    [198]="Alexandro",[203]="Hoyeon",[205]="Saengwon",[207]="Seonpung",[210]="Haesu",[242]="Grace",
    [243]="Evan",[289]="Lucian",[301]="Salvatore",[305]="Lasagna",[338]="Panna Cotta",
    [341]="Mont Blanc",[344]="Prosciutto",[353]="VOLKOV",[355]="SERGEI",[356]="AIRA",
    [240]="Calleb",[380]="Vice Principal",[365]="Wyat",[362]="Hyeonuk",[369]="Logan",
    [377]="Younghoon",[24]="Benchpress",[27]="Jihwang",[49]="Brokoli",[59]="Cheolwon",[68]="Jinwoo",
    [71]="Boreum",[82]="Seonggwang",[104]="Luminor",[235]="Oliver",[257]="Dima Orlo",
    [181]="Benedetto",[187]="Lazio",[16]="Kakek Misterius",[42]="Arugur",[75]="Hyeonuk",
    [85]="Kakak Kecil",[91]="Jae Seok",[220]="Hurim",[224]="Jihwan",[263]="Lars Grell",
    [278]="Prosecco",[299]="Massimo",[327]="Vescari",[45]="Alex",[53]="Choi Raksasa",
    [62]="Mirae",[88]="Han Beol",[94]="Amane",[101]="Jun Ho",[109]="Sota",[167]="Seokgi",
    [174]="Francesco",[177]="Giovanni",[190]="Maximus",[193]="Anselmo",[259]="Kira",[291]="Rian",
    [306]="Peppino",[33]="3C",[56]="Junseo",[107]="Sae Sak",[184]="Federico",[217]="Daram",
    [272]="Pizzelle",[116]="B0 Player",[35]="Seokgyu",[281]="Bazia",[331]="Aria",[13]="Yeong Jae",
    [315]="Duil",[5]="Inryeok",[21]="Barae",[170]="Giallo",[388]="Seo Yuna",[1] = "Siwoo"
}

local POS_MB = {
    [387]="Han Gitae",[160]="SangHyeon",[44]="Atis",[96]="Yamadera",[19]="Heesung",[163]="Roberto",
    [229]="Mike",[218]="Hanra",[282]="Hari MB",[308]="Seol Hwa",[350]="Yuri",[322]="Claire",
    [334]="Isebel MB",[283]="Crow",[232]="Clyde",[374]="Saya",[202]="Taeho",[206]="Jihwi",
    [213]="Daewoong",[262]="Oren Bel",[266]="Theo",[288]="Bruno",[293]="Enrico",[297]="Eustachio",
    [310]="Eustachio B",[326]="Valerio",[340]="Granita",[343]="Calzone",[346]="Cacciatore",
    [23]="Squat",[67]="Yongbi",[171]="Verde",[178]="Alessia",[269]="Alessia B",[261]="Elva",
    [270]="Cappuccino",[274]="Cappuccino B",[271]="Barolo",[277]="Barolo B",[358]="Mia",
    [366]="Shane",[368]="Walker",[216]="Dalji",[249]="Kazuki",[26]="Pureum",[38]="Ilbong",
    [48]="Kevin",[74]="Jiho",[103]="Park Cheetah",[108]="Taichi",[173]="Marco",[233]="Liam",
    [253]="Milo Zern",[258]="Jure",[186]="Piano",[29]="Yeongseok",[52]="Big Raksasa",
    [55]="Donggeon",[58]="Min Gyu",[64]="Hyukjin",[81]="Seongjwa",[90]="Seung Seon",
    [93]="Mizuho",[113]="Jangmi",[169]="Oslo",[183]="Giacomo",[189]="Lucius",[192]="Leopoldo",
    [239]="Gavin",[41]="Sivir",[61]="Uiseong",[78]="Heontae",[166]="Dupal",[176]="Ricardo",
    [280]="Cinnamiel",[32]="2KNO3",[196]="Alessia C",[223]="Donggwwan",[12]="Eunsup",
    [15]="KwonMin",[106]="Nae Gi",[6]="Hyunsoo",[8]="Hanadu",[316]="Kim Jisam",
    [303]="Kim Jisam B",[20]="Isijak",[76]="Dabin",[2] = "Jaeho"
}

local POS_SE = {
    [386]="Kang Sejin",[200]="Seolhwa",[381]="Haeun",[349]="Iris",[31]="Ahyeon",[221]="Muyeong",
    [95]="Sohee",[161]="NN",[313]="NN(Surfer)",[40]="Lisia",[230]="Sara SE",[252]="Ellio",
    [286]="Zero",[323]="Sif",[333]="Oasis",[157]="Viola",[231]="Tania",[215]="Sodam",
    [375]="Jihoon",[7]="Jaehyun",[364]="Dahee",[367]="Rex",[370]="Daisy",[69]="Hahyeon",
    [244]="Hahyeon B",[97]="Shimura",[201]="Kyle",[204]="Mio",[208]="Suri",[209]="Suhan",
    [214]="Kim Beom",[219]="Bidan",[241]="Isla",[267]="Sven",[273]="Tartufo",[290]="Miren",
    [298]="Tiziano",[300]="Fedele",[304]="Montepulciano",[330]="Chris",[348]="Chris B",
    [339]="Semufreddo",[342]="Cornetto",[345]="Milanese",[22]="Proteo",[54]="Choji",
    [66]="Hyoung Sup",[89]="Seon Woo",[102]="Shin Sok",[180]="Leonardo",[191]="Ignacio",
    [197]="Andrea",[256]="Leo Haas",[260]="Mika Dorn",[285]="NIKOLAI",[185]="Ranti",
    [57]="Dong Yeon",[80]="Seonghun",[83]="Jini",[86]="Gwangun",[112]="Nari",[211]="Nari B",
    [168]="Falco",[182]="Lorenzo",[188]="Marcus",[234]="Lucas",[250]="Canon",[255]="Oskar",
    [292]="Enzo",[329]="Onyx",[354]="IVAN",[37]="Cheolsu",[43]="Robert",[47]="Paul",
    [73]="CaCO3",[100]="Dae Hun",[110]="Jovan",[172]="Mateo",[175]="Giuseppe",
    [179]="Valentino",[265]="Kian",[276]="Chianti",[307]="Pesto",[309]="Fedele B",[3] = "Ohjun",
    [60]="Howon",[63]="Hang Un",[92]="Sachika",[14]="KimMin",[28]="Jaewook",[34]="Jongha",
    [77]="Junhyung",[165]="Woo Seok",[25]="Sin Bada",[105]="Pramadara",[195]="Valentina",
    [279]="Saffira",[11]="Sehwan",[9]="Jeongbin",[4]="Victor",[287]="Dahee",[314]="Sunhang"
}

local function getPositionByID(id)
    local num = tonumber(id)
    if not num then return nil end
    if POS_WS[num] then return "WS" end
    if POS_MB[num] then return "MB" end
    if POS_SE[num] then return "SE" end
    return nil
end

local function shuffleTable(t)
    for i = #t, 2, -1 do
        local j = math.random(i)
        t[i], t[j] = t[j], t[i]
    end
end

-- ==========================================
-- FITUR CUSTOM INJECT SKILL (SAVE/LOAD FILE)
-- ==========================================
local customSkillFile = "/sdcard/Hanzz_Custom_Skill.txt"
local customSkillConfig = {} -- Format: customSkillConfig[charName] = { ["Skill Asal"] = "Skill Baru" }

-- Fungsi muat file custom skill
local function loadCustomSkillConfig()
    customSkillConfig = {}
    local file = io.open(customSkillFile, "r")
    if file then
        for line in file:lines() do
            -- Format: NamaKarakter|SkillAsal|SkillBaru
            local charName, oldSkill, newSkill = line:match("^(.-)|(.-)|(.*)$")
            if charName and oldSkill and newSkill then
                if not customSkillConfig[charName] then customSkillConfig[charName] = {} end
                customSkillConfig[charName][oldSkill] = newSkill
            end
        end
        file:close()
    end
end

-- Fungsi simpan file custom skill
local function saveCustomSkillConfig()
    local file = io.open(customSkillFile, "w")
    if file then
        for charName, skills in pairs(customSkillConfig) do
            for oldSkill, newSkill in pairs(skills) do
                file:write(charName .. "|" .. oldSkill .. "|" .. newSkill .. "\n")
            end
        end
        file:close()
        gg.toast("✅ Konfigurasi berhasil disimpan ke file!")
    else
        gg.toast("❌ Gagal menyimpan file custom skill!")
    end
end

-- Otomatis load saat script jalan
loadCustomSkillConfig()

function menuCustomInjectSkill()
    gg.setVisible(false)
    
    local m = gg.choice({
        "➕ Tambah/Edit Skill Custom",
        "📄 Lihat Config Tersimpan",
        "💾 Save Config ke File",
        "🔄 Load Config dari File",
        "Kembali"
    }, nil, "⚙️ Custom Inject Skill Menu")

    if not m or m == 5 then return charMenu() end

    if m == 1 then
        -- Bagian Tambah/Edit Skill
        local charListMenu = {"Kembali"}
        local charNameList = {}
        for charName, _ in pairs(skillDatabase) do
            table.insert(charListMenu, charName)
        end
        
        local pickCharMenu = gg.choice(charListMenu, nil, "Pilih Karakter:")
        if not pickCharMenu or pickCharMenu == 1 then return menuCustomInjectSkill() end
        
        local selectedChar = charListMenu[pickCharMenu]
        
        local skillListMenu = {}
        local skillNameList = {}
        for skillName, _ in pairs(skillDatabase[selectedChar]) do
            skillListMenu[#skillListMenu + 1] = skillName
            skillNameList[#skillNameList + 1] = skillName
        end

        local choices = gg.multiChoice(skillListMenu, nil, "Pilih Skill " .. selectedChar .. " yang mau diedit")
        if not choices then return menuCustomInjectSkill() end

        local selectedSkills = {}
        for i = 1, #skillListMenu do
            if choices[i] then
                table.insert(selectedSkills, skillNameList[i])
            end
        end

        if #selectedSkills == 0 then
            gg.alert("Kamu tidak memilih skill apapun!")
            return menuCustomInjectSkill()
        end

        if not customSkillConfig[selectedChar] then customSkillConfig[selectedChar] = {} end

        for i, namaSkill in ipairs(selectedSkills) do
            local targetList = {}
            for _, v in ipairs(allNormalSkills) do table.insert(targetList, v) end
            
            local pilihTarget = gg.choice(targetList, nil, "("..i.."/"..#selectedSkills..") Ubah " .. namaSkill .. " Jadi:")
            if pilihTarget then
                local targetName = targetList[pilihTarget]
                customSkillConfig[selectedChar][namaSkill] = targetName
                gg.toast("✅ " .. namaSkill .. " -> " .. targetName)
            end
            gg.sleep(100)
        end
        
        -- Otomatis save abis ngedit
        saveCustomSkillConfig()
        gg.alert("✅ Konfigurasi " .. selectedChar .. " berhasil diperbarui dan disimpan!")
        return menuCustomInjectSkill()
        
    elseif m == 2 then
        -- Lihat Config
        local text = "📄 DAFTAR CUSTOM SKILL:\n─────────────────\n"
        local count = 0
        for charName, skills in pairs(customSkillConfig) do
            text = text .. "🔹 " .. charName .. "\n"
            for oldSkill, newSkill in pairs(skills) do
                text = text .. "   " .. oldSkill .. " ➔ " .. newSkill .. "\n"
                count = count + 1
            end
        end
        if count == 0 then text = text .. "(Belum ada skill yang dikonfigurasi)" end
        gg.alert(text)
        return menuCustomInjectSkill()
        
    elseif m == 3 then
        saveCustomSkillConfig()
        return menuCustomInjectSkill()
        
    elseif m == 4 then
        loadCustomSkillConfig()
        gg.alert("✅ Konfigurasi berhasil dimuat ulang dari file!")
        return menuCustomInjectSkill()
    end
end

function menuInjectAllRandom()
    gg.setVisible(false)
    loadCustomSkillConfig() 

    local inputCount = gg.prompt({"Masukkan jumlah karakter yang lu punya:"}, {"55"}, {"number"})
    if not inputCount or not inputCount[1] then return charMenu() end
    local charCount = tonumber(inputCount[1])
    if not charCount or charCount <= 0 then
        gg.alert("Jumlah tidak valid!")
        return charMenu()
    end

    -- Tanya mau inject karakter apa skill-nya
    local charListForInject = {"Tidak ada", "Kembali"}
    local charNameForInject = {}
    for charName, _ in pairs(skillDatabase) do
        table.insert(charListForInject, charName)
    end
    
    local pilihInjectSkill = gg.choice(charListForInject, nil, "Pilih karakter yang skill-nya mau di-inject\n(Atau 'Tidak ada' jika tidak mau)")
    if not pilihInjectSkill or pilihInjectSkill == 2 then return charMenu() end
    
    local selectedCharSkill = nil
    if pilihInjectSkill > 1 then
        selectedCharSkill = charListForInject[pilihInjectSkill]
        if not customSkillConfig[selectedCharSkill] then
            gg.alert("⚠️ Skill untuk " .. selectedCharSkill .. " belum di konfigurasi!\nSilakan atur dulu di menu Custom Inject Skill.")
            return charMenu()
        end
    end

    gg.clearResults()
    gg.setRanges(MEMORY_RANGE)
    gg.toast("Mencari alamat dasar karakter...")

    -- Scan Base
    gg.searchNumber("206398", gg.TYPE_DOUBLE)
    local res1 = gg.getResults(100000)
    if #res1 == 0 then
        gg.alert("Gagal: Base address tidak ditemukan!")
        return charMenu()
    end

    local shiftedResults = {}
    for _, v in ipairs(res1) do
        shiftedResults[#shiftedResults + 1] = {address = v.address - 0x10, flags = gg.TYPE_DOUBLE}
    end
    gg.clearResults()
    gg.loadResults(shiftedResults)

    gg.refineNumber("226618", gg.TYPE_DOUBLE)
    local res2 = gg.getResults(100000)
    if #res2 == 0 then
        gg.alert("Gagal: Refine tidak ditemukan!")
        return charMenu()
    end

    local finalBase = res2[1].address - 0x1C0

    -- Kumpulkan SEMUA address dari scan
    local scanList = {}
    for i = 1, charCount do
        scanList[#scanList + 1] = {address = finalBase - (i * 0x150), flags = gg.TYPE_DOUBLE}
    end
    gg.loadResults(scanList)
    local values = gg.getValues(scanList)

    -- Kelompokkan hasil scan
    local detectedWS, detectedMB, detectedSE, slotKosong = {}, {}, {}, {}

    local function getPos(id)
        id = tonumber(id)
        if not id then return nil end
        if POS_WS[id] then return "WS" end
        if POS_MB[id] then return "MB" end
        if POS_SE[id] then return "SE" end
        return nil
    end

    for _, v in ipairs(values) do
        local id = tonumber(v.value)
        local pos = getPos(id)
        if pos == "WS" then
            table.insert(detectedWS, {addr = v.address, id = id})
        elseif pos == "MB" then
            table.insert(detectedMB, {addr = v.address, id = id})
        elseif pos == "SE" then
            table.insert(detectedSE, {addr = v.address, id = id})
        else
            table.insert(slotKosong, {addr = v.address, id = id})
        end
    end

    -- Input stats
    local statsWS, statsMB, statsSE
    if #detectedWS > 0 then
        local p = gg.prompt({"[WS] Attack:", "[WS] Defense:", "[WS] Speed:", "[WS] Jump:", "[WS] Ascension:"}, {"200", "250", "50", "90", "5"}, {"number","number","number","number","number"})
        if not p then return charMenu() end
        statsWS = {atk=tonumber(p[1]) or 200, def=tonumber(p[2]) or 300, spd=tonumber(p[3]) or 50, jmp=tonumber(p[4]) or 200, asc=tonumber(p[5]) or 5}
    end
    if #detectedMB > 0 then
        local p = gg.prompt({"[MB] Attack:", "[MB] Defense:", "[MB] Speed:", "[MB] Jump:", "[MB] Ascension:"}, {"50", "250", "50", "50", "5"}, {"number","number","number","number","number"})
        if not p then return charMenu() end
        statsMB = {atk=tonumber(p[1]) or 200, def=tonumber(p[2]) or 300, spd=tonumber(p[3]) or 50, jmp=tonumber(p[4]) or 200, asc=tonumber(p[5]) or 5}
    end
    if #detectedSE > 0 then
        local p = gg.prompt({"[SE] Attack:", "[SE] Defense:", "[SE] Speed:", "[SE] Jump:", "[SE] Ascension:"}, {"50", "250", "50", "50", "5"}, {"number","number","number","number","number"})
        if not p then return charMenu() end
        statsSE = {atk=tonumber(p[1]) or 200, def=tonumber(p[2]) or 300, spd=tonumber(p[3]) or 50, jmp=tonumber(p[4]) or 200, asc=tonumber(p[5]) or 5}
    end

    local skinDB = {
        [98]={1,4},[225]={7,19},[251]={17,9},[284]={22},[230]={8},[252]={16},[31]={5},[95]={12},
        [161]={11},[40]={13},[322]={21},[218]={23,6},[282]={18},[30]={3},[159]={2,26},[231]={25},
        [228]={10},[212]={14},[286]={15},[323]={20},[157]={24}
    }

    local wsIDs = {"98","99","164","324","352","296","325","159","284","225","351","158","251","212","50","39","65","30","10","228","388"}
    local mbIDs = {"19","163","44","96","160","218","229","232","282","283","322","350","387"}
    local seIDs = {"200","161","157","95","31","40","221","215","230","231","252","286","323","349","375"}

    local wajibWS = {98,324,296,325,159,284,351,225,99,148,164,248}
    local wajibMB = {387,160,96,218,282,381,322}
    local wajibSE = {230,286,252,161,231}

    local editList = {}

    -- Fungsi andalan buat nembak SEMUA slot (ada perulangan otomatis)
    local function processPos(pool, targetIDs, wajibIDs, stats)
        if #pool == 0 then return end
        
        -- Siapin urutan karakter acak
        local finalList = {}
        local shuffledWajib = {}
        for _, id in ipairs(wajibIDs) do table.insert(shuffledWajib, id) end
        shuffleTable(shuffledWajib)

        local shuffledSisa = {}
        for _, id in ipairs(targetIDs) do
            local isWajib = false
            for _, w in ipairs(wajibIDs) do if tonumber(id) == w then isWajib = true break end end
            if not isWajib then table.insert(shuffledSisa, id) end
        end
        shuffleTable(shuffledSisa)

        for _, id in ipairs(shuffledWajib) do table.insert(finalList, id) end
        for _, id in ipairs(shuffledSisa) do table.insert(finalList, id) end

        local slotPlan = {}
        local poolIdx = 1
        local isNishikawa = function(id) return id == 98 or id == 99 or id == 164 end

        -- LOOPING: Selama slot di pool masih ada, terus isi
        while #slotPlan < #pool do
            local charID = tonumber(finalList[poolIdx])
            local skins = skinDB[charID]

            if isNishikawa(charID) then
                table.insert(slotPlan, {id = charID, skin = -1})
            elseif skins and #skins >= 2 then
                table.insert(slotPlan, {id = charID, skin = skins[1]})
                if #slotPlan < #pool then table.insert(slotPlan, {id = charID, skin = skins[2]}) end
            elseif skins and #skins == 1 then
                table.insert(slotPlan, {id = charID, skin = skins[1]})
            else
                table.insert(slotPlan, {id = charID, skin = -1})
            end
            
            poolIdx = poolIdx + 1
            -- Kalau udah mentok ujung list, balik ke awal lagi (biar slot ga kosong)
            if poolIdx > #finalList then poolIdx = 1 end
        end

        -- Tembak ke memory
        for i, item in ipairs(pool) do
            local plan = slotPlan[i]
            if plan then
                editList[#editList + 1] = {address = item.addr, flags = gg.TYPE_DOUBLE, value = plan.id}
                editList[#editList + 1] = {address = item.addr + 0x120, flags = gg.TYPE_DOUBLE, value = plan.skin}
                
                if stats then
                    editList[#editList + 1] = {address = item.addr + 0xB0, flags = gg.TYPE_DOUBLE, value = stats.atk}
                    editList[#editList + 1] = {address = item.addr + 0xF0, flags = gg.TYPE_DOUBLE, value = stats.def}
                    editList[#editList + 1] = {address = item.addr + 0x20, flags = gg.TYPE_DOUBLE, value = stats.spd}
                    editList[#editList + 1] = {address = item.addr + 0x60, flags = gg.TYPE_DOUBLE, value = stats.jmp}
                    editList[#editList + 1] = {address = item.addr + 0xA0, flags = gg.TYPE_DOUBLE, value = stats.asc}
                end
            end
        end
    end

    -- Eksekusi semua bagian
    processPos(detectedWS, wsIDs, wajibWS, statsWS)
    processPos(detectedMB, mbIDs, wajibMB, statsMB)
    processPos(detectedSE, seIDs, wajibSE, statsSE)
    
    -- Kalau masih ada slotKosong (Minseo Jo / Basic), ubah jadi WS acak
    if #slotKosong > 0 then
        local sisaStats = statsWS or {atk=200, def=300, spd=50, jmp=200, asc=5}
        processPos(slotKosong, wsIDs, wajibWS, sisaStats)
    end

    if #editList == 0 then
        gg.alert("Tidak ada perubahan yang diterapkan.")
        return charMenu()
    end

    gg.toast("Menerapkan Karakter...")
    local ok = pcall(function() gg.setValues(editList) end)
    gg.clearResults()

    -- Eksekusi Inject Skill
    if ok and selectedCharSkill then
        gg.toast("Mencari Skill " .. selectedCharSkill .. "...")
        local config = customSkillConfig[selectedCharSkill]
        local skillDatabaseChar = skillDatabase[selectedCharSkill]
        
        local skillEdits = {}
        
        for oldSkill, newSkill in pairs(config) do
            if skillDatabaseChar[oldSkill] then
                local searchHex = skillDatabaseChar[oldSkill].searchHex
                local refineHex = skillDatabaseChar[oldSkill].refineHex
                local offsetStart = skillDatabaseChar[oldSkill].offsetStart or 0
                
                gg.clearResults()
                gg.setRanges(MEMORY_RANGE)
                gg.searchNumber(searchHex, gg.TYPE_BYTE)
                local res = gg.getResults(100000)
                
                if #res > 0 then
                    gg.refineNumber(refineHex, gg.TYPE_BYTE)
                    local targetRes = gg.getResults(100000)
                    local finalAddress = 0
                    if #targetRes > 0 then
                        finalAddress = targetRes[1].address 
                    else
                        finalAddress = res[1].address + offsetStart
                    end
                    
                    local hexBaru = ""
                    for idx, normalName in ipairs(allNormalSkills) do
                        if normalName == newSkill then
                            hexBaru = allNormalHex[idx]
                            break
                        end
                    end
                    
                    if hexBaru ~= "" then
                        local urutan = hexToDecimalTable(hexBaru)
                        for j = 1, #urutan do
                            skillEdits[#skillEdits + 1] = {
                                address = finalAddress + (j - 1),
                                flags = gg.TYPE_BYTE,
                                value = urutan[j]
                            }
                        end
                    end
                end
                gg.sleep(100)
            end
        end
        
        if #skillEdits > 0 then
            local skillOk = pcall(function() gg.setValues(skillEdits) end)
            gg.clearResults()
            if skillOk then
                gg.alert("✅ Inject Skill untuk " .. selectedCharSkill .. " berhasil!")
            else
                gg.alert("❌ Gagal mengedit skill.")
            end
        else
            gg.alert("⚠️ Skill asal tidak ditemukan di memory!")
        end
    end

    charMenu()
end

--Pilihan char menu
function charMenu()
    gg.setVisible(false)
    local menuTitle = "CHARACTER MENU [" .. tostring(USER_NAME) .. "] - " .. tostring(MEMORY_NAME)
    
    local menu = gg.choice ({
        "⭐Siwoo",
        "⭐Ohjun",
        "⭐Jaejo",
        "👑Scan Character🔍",
        "🎲 1x Inject All Character",
        "⚙️ Custom Inject Skill", -- MENU BARU
        "Kembali"
    }, nil, menuTitle)
    
    if menu == 1 then quickScanChar("Siwoo")
    elseif menu == 2 then 
        quickScanChar("Ohjun")
    elseif menu == 3 then 
        quickScanChar("Jaeho")
    elseif menu == 4 then 
        menuEditCharacter()
    elseif menu == 5 then 
        menuInjectAllRandom()
    elseif menu == 6 then 
        menuCustomInjectSkill() -- FUNGSI BARU
    elseif menu == 7 then 
        menuUtama() end
end

--MENU UTAMA
function menuUtama()
    gg.setVisible(false)
    local menuTitle = "Hanzz_TSC [" .. tostring(USER_NAME) .. "] - " .. tostring(MEMORY_NAME)

    local menu = gg.choice({
        "    ▸      👤Character Menu",
        "    ▸      👑Edit Character V2", -- MENU BARU
        "    ▸      ⚔️Mastery Menu",
        "    ▸      📝Config Skill All Character",
        "    ▸      ⭐ Favorite Skill",
        "    ▸      🏐 Volleyball Skin",
        "    ▸      🖼️ Background Skin",
        "    ▸      🎮Gameplay Menu",
        "    ▸      🛠️Game Maker Tools",
        "    ▸      🌐Menu UID",
        "    ▸      ⚙️Setup Memory",
        "    ▸      Exit"
    }, nil, menuTitle)

    if menu == nil then
        return
    elseif menu == 1 then
        charMenu()
    elseif menu == 2 then
        menuEditCharV2() -- PANGGIL FUNGSI BARU
    elseif menu == 3 then
        masteryMenu()
    elseif menu == 4 then
        menuPilihKarakter()
    elseif menu == 5 then
        menuFavoriteSkill()
    elseif menu == 6 then
        menuVolleyballSkin()
    elseif menu == 7 then
        menuBackgroundSkin()
    elseif menu == 8 then
        gameplayMenu()
    elseif menu == 9 then
        showFpsMode()
    elseif menu == 10 then
        menuUID()
    elseif menu == 11 then
        pilihMemory()
    elseif menu == 12 then
        gg.clearResults()
        goodbye()
    end
end

-- JALANKAN LOGIN DULU
loginSystem()

while true do
    if gg.isVisible() then
        gg.setVisible(false)
        if MEMORY_NAME == nil then
            pilihMemory()
        else
            menuUtama()
        end
    end
end