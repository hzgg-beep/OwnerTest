-- Hanzz_TSC Script
-- Template by Chardox Core
MEMORY_RANGE = nil
MEMORY_NAME = nil
USER_NAME = nil

-- ==========================================
-- KONFIGURASI FILE & URL PASTEBIN
-- ==========================================
local nameFile = "/sdcard/Notes/Hanzz_User.txt"
local keyFile = "/sdcard/Notes/Hanzz_Key.txt"
local RAW_PASTEBIN_URL = "https://pastebin.com/raw/REnycS4A"

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
    ["Nishikawa"] = {
        ["ThunderSpike_Highschool"] = {
            searchHex = "h67 6D 6C 5F 53 63 72 69 70 74 5F 53 6B 69 6C 6C 46 65 61 74 75 72 65 5F 54 68 75 6E 64 65 72 53 70 69 6B 65 5F 48 69 67 68 73 63 68 6F 6F 6C 00 23 00 00 00 53 6B 69 6C 6C 46 65 61 74 75 72 65 5F",
            refineHex = "h54 68 75",
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
    gg.searchNumber("hA0 1E 00 36", gg.TYPE_BYTE)
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
    gg.searchNumber("hFA CB 94 FF 83 04 D1 E8 5B 00 FD FD 7B 0C A9 FC 6F 0D A9 FA 67 0E A9", gg.TYPE_BYTE)
    
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
                listRevert[#listRevert + 1] = {address=addr, flags=gg.TYPE_DOUBLE, value=1573.12}
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
    gg.searchNumber("1573,12", gg.TYPE_DOUBLE)
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
                value = 1500
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
        "Kembali"
    }, nil, "Gameplay Menu - Hanzz_TSC")

    if menu == 1 then dummyEnemy()
    elseif menu == 2 then fastWin()
    elseif menu == 3 then EditScoreMenu()
    elseif menu == 4 then speedHack()
    elseif menu == 5 then menuUtama()
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
    
    -- Ambil semua nama skill sesuai karakter yang dipilih
    local skillListMenu = {}
    local skillNameList = {}
    for skillName, _ in pairs(skillDatabase[karakter]) do
        skillListMenu[#skillListMenu + 1] = skillName
        skillNameList[#skillNameList + 1] = skillName
    end
    skillListMenu[#skillListMenu + 1] = "Kembali"

    local m = gg.choice(skillListMenu, nil, "Skill " .. karakter)
    if not m then return end
    
    if m == #skillListMenu then
        menuPilihKarakter()
    else
        local selectedSkill = skillNameList[m]
        eksekusiEditSkill(karakter, selectedSkill)
    end
end

function eksekusiEditSkill(karakter, namaSkill)
    gg.setVisible(false)
    local skillData = skillDatabase[karakter][namaSkill]
    
    gg.clearResults()
    gg.setRanges(MEMORY_RANGE)
    
    gg.toast("Mengecek kode " .. namaSkill .. "...")
    
    -- 1. SEARCH PAKE HEX BYTE
    gg.searchNumber(skillData.searchHex, gg.TYPE_BYTE)
    local res = gg.getResults(100000)
    
    if #res == 0 then
        gg.alert("❌ Gagal: Kode Hex " .. namaSkill .. " tidak ditemukan di memory!")
        gg.clearResults()
        menuPilihSkill(karakter)
        return
    end
    
    -- 2. KALAU KETEMU, TANYA MAU JADI APA
    local m = gg.choice({
        "RaulFirstImpact",
        "ThunderSpike_Skin Highschool",
        "WhiteSpike",
        "Always Parry",
        "Always Noon",
        "Metal Blood",
        "Thunder Spike Original",
        "Thunder Spike_Skin Black",
        "Vertical Spike",
        "Vertical Spike Jenny",
        "Beast Spike Raul",
        "Beast Spike Raul For Event AI",
        "Blue Dragon",
        "Blue Dragon_Skin Dosa",
        "Blue Dragon_Skin Redhood",
        "Parry_Skin Homunculus",
        "Parry_Skin Wedding",
        "Ryuhyun Redhood Furst Impact",
        "High Vertical Serve Toss Black Thunder",
        "Isabel Homunculus Last Spike",
        "Sky Serve Lisia_Skin Rudolph",
        "Chapter 12 Beast Spike For Event AI",
        "Chapter 12 Beast Spike For Event AI",
        "Calm Before The Storm",
        "Coward Jacob Horror",
        "Default",
        "",
        "",
        "",
        "",
        "",
        "",
        "Kembali"
    }, nil, "Kode Ditemukan!\nUbah " .. namaSkill .. " Jadi:")
    
    local hexBaru = ""
    if m == 1 then hexBaru = "52 61 75 6C 46 69 72 73 74 49 6D 70 61 63 74 00"
    elseif m == 2 then hexBaru = "54 68 75 6E 64 65 72 53 70 69 6B 65 5F 48 69 67 68 73 63 68 6F 6F 6C 00"
    elseif m == 3 then hexBaru = "57 68 69 74 65 53 70 69 6B 65 00"
    elseif m == 4 then hexBaru = "50 61 72 72 79 5F 41 6C 77 61 79 73 50 61 72 72 79 00"
    elseif m == 5 then hexBaru = "41 6C 77 61 79 73 4E 6F 6F 6E 00"
    elseif m == 6 then hexBaru = "4D 65 74 61 6C 42 6C 6F 6F 64 00"
    elseif m == 7 then hexBaru = "54 68 75 6E 64 65 72 53 70 69 6B 65 00"
    elseif m == 8 then hexBaru = "54 68 75 6E 64 65 72 53 70 69 6B 65 5F 53 6B 69 6E 42 6C 61 63 6B 00"
    elseif m == 9 then hexBaru = "44 65 65 70 53 70 69 6B 65 00"
    elseif m == 10 then hexBaru = "44 65 65 70 53 70 69 6B 65 49 6E 73 74 65 61 64 46 65 69 6E 74 00"
    elseif m == 11 then hexBaru = "42 65 61 73 74 53 70 69 6B 65 00"
    elseif m == 12 then hexBaru = "42 65 61 73 74 53 70 69 6B 65 46 6F 72 41 49 00"
    elseif m == 13 then hexBaru = "42 6C 75 65 44 72 61 67 6F 6E 00"
    elseif m == 14 then hexBaru = "42 6C 75 65 44 72 61 67 6F 6E 5F 53 6B 69 6E 44 6F 73 61 00"
    elseif m == 15 then hexBaru = "42 6C 75 65 44 72 61 67 6F 6E 5F 53 6B 69 6E 52 65 64 48 6F 6F 64 00"
    elseif m == 16 then hexBaru = "50 61 72 72 79 5F 53 6B 69 6E 48 6F 6D 75 6E 63 75 6C 75 73 00"
    elseif m == 17 then hexBaru = "50 61 72 72 79 5F 53 6B 69 6E 57 65 64 64 69 6E 67 00"
    elseif m == 18 then hexBaru = "52 65 64 48 6F 6F 64 52 79 75 68 79 75 6E 46 69 72 73 74 49 6D 70 61 63 74 00"
    elseif m == 19 then hexBaru = "48 69 67 68 56 65 72 74 69 63 61 6C 53 65 72 76 65 54 6F 73 73 5F 42 6C 61 63 6B 54 68 75 6E 64 65 72 00"
    elseif m == 20 then hexBaru = "49 73 61 62 65 6C 48 6F 6D 75 6E 63 75 6C 75 73 4C 61 73 74 53 70 69 6B 65 00"
    elseif m == 21 then hexBaru = "53 6B 79 53 65 72 76 65 5F 53 6B 69 6E 52 75 64 6F 6C 70 68 00"
    elseif m == 22 then hexBaru = "43 68 61 70 74 65 72 31 32 42 65 61 73 74 53 70 69 6B 65 46 6F 72 41 49 00"
    elseif m == 23 then hexBaru = "43 68 61 70 74 65 72 31 31 42 65 61 73 74 53 70 69 6B 65 46 6F 72 41 49 00"
    elseif m == 24 then hexBaru = "43 61 6C 6D 42 65 66 6F 72 65 54 68 65 53 74 6F 72 6D 00"
    elseif m == 25 then hexBaru = "43 6F 77 61 72 64 4A 61 63 6F 62 48 6F 72 72 6F 72 00"
    elseif m == 26 then hexBaru = "44 65 66 61 75 6C 74 00"
    elseif m == 27 then hexBaru = ""
    elseif m == 28 then hexBaru = ""
    elseif m == 29 then hexBaru = ""
    elseif m == 30 then hexBaru = ""
    elseif m == 31 then hexBaru = ""
    elseif m == 32 then hexBaru = ""
    elseif m == 33 then
        gg.clearResults()
        menuPilihSkill(karakter)
        return
    else
        return
    end

    -- 3. REFINE PAKE HEX BYTE (h42 6C, dll)
    gg.refineNumber(skillData.refineHex, gg.TYPE_BYTE)
    local targetRes = gg.getResults(100000)
    
    local finalAddress = 0
    if #targetRes > 0 then
        -- Ambil hasil paling atas yang udah di-refine
        finalAddress = targetRes[1].address 
    else
        -- Kalau refine gagal, fallback ke hasil search awal + offsetStart
        finalAddress = res[1].address + skillData.offsetStart
    end
    
    -- 4. EKSEKUSI EDIT
    local editList = {}
    local urutan = hexToDecimalTable(hexBaru)
    
    for i = 1, #urutan do
        editList[#editList + 1] = {
            address = finalAddress + (i - 1),
            flags = gg.TYPE_BYTE,
            value = urutan[i]
        }
    end
    
    local ok = pcall(function() gg.setValues(editList) end)
    gg.clearResults()
    
    if ok then
        gg.alert("✅ Berhasil Mengubah " .. namaSkill .. "!")
    else
        gg.alert("❌ Gagal mengedit memory!")
    end
    
    gg.sleep(100)
    menuPilihSkill(karakter)
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

    -- 1. Cari Base Address
    gg.searchNumber("206398", gg.TYPE_DOUBLE)
    local res1 = gg.getResults(100000)
    if #res1 == 0 then
        gg.alert("Gagal: Base address tidak ditemukan!")
        return menuUtama()
    end

    local baseAddr = res1[1].address - 0x10
    gg.clearResults()
    gg.loadResults({{address = baseAddr, flags = gg.TYPE_DOUBLE}})
    
    -- 2. Refine
    gg.refineNumber("226618", gg.TYPE_DOUBLE)
    local res2 = gg.getResults(100000)
    if #res2 == 0 then
        gg.alert("Gagal: Refine tidak ditemukan!")
        return menuUtama()
    end

    local finalBase = res2[1].address + 0xB0
    gg.clearResults()

    -- 3. Scan karakter pake offset -150 berulang kali
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

    -- 4. Multi Choice buat milih karakter ASAL
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

    -- 5. Pilih Posisi Target (WS / MB / SE)
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
    local targetCharId = charIdList[pickChar]

-- 6. Input Skin (Setelah milih karakter)
local skinInfo = 
    "Daftar ID Skin:\n" ..
    "1: Nishikawa+High School\n" ..
    "4: Nishikawa+Black Thunder\n" ..
    "7: Ryuhyeon+Chief Disciple\n" ..
    "19: Ryuhyeon+Red Hood\n" ..
    "22: Lucas+Summer Training\n" ..
    "8: Sara SE+Water Splash\n" ..
    "16: Ellio+Star of the Encore\n" ..
    "5: Ahyeon+Style\n" ..
    "12: Sohee+Vampire\n" ..
    "11: NN+Surfer\n" ..
    "13: Lisia+Rudolph\n" ..
    "21: Claire+God Father\n" ..
    "23: Hanra+Summer Training\n" ..
    "18: Hari+Midnight\n" ..
    "3: Jaehyeon+Training\n" ..
    "17: Jenny+Shooting Star\n" ..
    "9: Jenny+Straw Hat\n" ..
    "2: Isabel+Wedding Dress\n" ..
    "10: Dave+Driver\n" ..
    "14: Hongshi+Maid\n" ..
    "15: Zero+Street Artist\n" ..
    "20: Sif+Bounty Hunter\n" ..
    "24: Viola+Summer Training\n" ..
    "25: Tania+Homunculus\n" ..
    "26: Isabel+Homunculus\n" ..
    "(-1: Default)"

local pSkin = gg.prompt({"Masukkan ID Skin (Kosongkan untuk skip):\n\n" .. skinInfo}, {"-1"}, {"number"})
local newSkin = nil
if pSkin and pSkin[1] and tostring(pSkin[1]):match("^%s*$") == nil then
    newSkin = tonumber(pSkin[1])
end

    -- 7. Input Stats
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

    -- 8. EKSEKUSI EDIT
    local editList = {}
    for _, idx in ipairs(selectedIndices) do
        local addr = charAddrMap[idx]
        
        -- Edit ID Karakter
        if targetCharId then
            editList[#editList + 1] = {address = addr, flags = gg.TYPE_DOUBLE, value = targetCharId}
        end
        
        -- Edit Skin (Jika diisi)
        if newSkin ~= nil then
            editList[#editList + 1] = {address = addr - 0x40, flags = gg.TYPE_DOUBLE, value = newSkin}
        end

        -- Edit Stats
        if newAttack then
            editList[#editList + 1] = {address = addr - 0x20, flags = gg.TYPE_DOUBLE, value = newAttack} 
            editList[#editList + 1] = {address = addr + 0x30, flags = gg.TYPE_DOUBLE, value = newDefense} 
            editList[#editList + 1] = {address = addr - 0xC0, flags = gg.TYPE_DOUBLE, value = newSpeed} 
            editList[#editList + 1] = {address = addr - 0x10, flags = gg.TYPE_DOUBLE, value = newJump} 
            editList[#editList + 1] = {address = addr - 0x70, flags = gg.TYPE_DOUBLE, value = newAsc} 
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
    for _, v in ipairs(resMastery) do off2[#off2+1] = {address = v.address + 0x20, flags = gg.TYPE_DOUBLE} end
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
    
    -- Tentukan ID asal
    local originID = "1"
    if targetPosName == "Ohjun" then originID = "3"
    elseif targetPosName == "Jaeho" then originID = "2" end

    gg.clearResults()
    gg.setRanges(MEMORY_RANGE)
    gg.toast("Mencari ID " .. targetPosName .. "...")

    -- 1. Cari nilai -1 pertama
    gg.searchNumber("-1", gg.TYPE_DOUBLE)
    local res1 = gg.getResults(100000)
    if #res1 == 0 then
        gg.alert("❌ Gagal: Nilai -1 tidak ditemukan!")
        return charMenu()
    end

    -- 2. Offset -0x10 dari hasil pertama
    local off1 = {}
    for _, v in ipairs(res1) do off1[#off1+1] = {address = v.address + 0x50, flags = gg.TYPE_DOUBLE} end
    gg.loadResults(off1)

    -- 3. Refine -1
    gg.refineNumber("-1", gg.TYPE_DOUBLE)
    local res2 = gg.getResults(100000)
    if #res2 == 0 then
        gg.alert("❌ Gagal: Refine -1 pertama gagal!")
        return charMenu()
    end

    -- 4. Offset -0x10 lagi
    local off2 = {}
    for _, v in ipairs(res2) do off2[#off2+1] = {address = v.address - 0x10, flags = gg.TYPE_DOUBLE} end
    gg.loadResults(off2)

    -- 5. Refine -1 lagi
    gg.refineNumber("-1", gg.TYPE_DOUBLE)
    local res3 = gg.getResults(100000)
    if #res3 == 0 then
        gg.alert("❌ Gagal: Refine -1 kedua gagal!")
        return charMenu()
    end

    -- 6. Offset -0x10 lagi
    local off3 = {}
    for _, v in ipairs(res3) do off3[#off3+1] = {address = v.address - 0x10, flags = gg.TYPE_DOUBLE} end
    gg.loadResults(off3)

    -- 7. Cari ID Karakter dari titik ini
    gg.searchNumber(originID, gg.TYPE_DOUBLE)
    local resFinal = gg.getResults(100000)
    
    if #resFinal == 0 then
        gg.alert("❌ Gagal: ID " .. targetPosName .. " (" .. originID .. ") tidak ditemukan dari pola -1!")
        gg.clearResults()
        return charMenu()
    end

    -- Ambil alamat pertama yang ketemu
    local targetAddr = resFinal[1].address
    gg.clearResults()

    -- ==========================================
    -- MASUK KE MENU EDIT
    -- ==========================================
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

    -- Input Skin
local skinInfo = 
    "Daftar ID Skin:\n" ..
    "1: Nishikawa+High School\n" ..
    "4: Nishikawa+Black Thunder\n" ..
    "7: Ryuhyeon+Chief Disciple\n" ..
    "19: Ryuhyeon+Red Hood\n" ..
    "22: Lucas+Summer Training\n" ..
    "8: Sara SE+Water Splash\n" ..
    "16: Ellio+Star of the Encore\n" ..
    "5: Ahyeon+Style\n" ..
    "12: Sohee+Vampire\n" ..
    "11: NN+Surfer\n" ..
    "13: Lisia+Rudolph\n" ..
    "21: Claire+God Father\n" ..
    "23: Hanra+Summer Training\n" ..
    "18: Hari+Midnight\n" ..
    "3: Jaehyeon+Training\n" ..
    "17: Jenny+Shooting Star\n" ..
    "9: Jenny+Straw Hat\n" ..
    "2: Isabel+Wedding Dress\n" ..
    "10: Dave+Driver\n" ..
    "14: Hongshi+Maid\n" ..
    "15: Zero+Street Artist\n" ..
    "20: Sif+Bounty Hunter\n" ..
    "24: Viola+Summer Training\n" ..
    "25: Tania+Homunculus\n" ..
    "26: Isabel+Homunculus\n" ..
    "(-1: Default)"

    local pSkin = gg.prompt({"Masukkan ID Skin (Kosongkan untuk skip):\n\n" .. skinInfo}, {"-1"}, {"number"})
    local newSkin = nil
    if pSkin and pSkin[1] and tostring(pSkin[1]):match("^%s*$") == nil then
        newSkin = tonumber(pSkin[1])
    end

    -- Input Stats
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

    -- Eksekusi Edit
    local editList = {}
    
    if targetCharId then
        editList[#editList + 1] = {address = targetAddr, flags = gg.TYPE_DOUBLE, value = targetCharId}
    end
    if newSkin ~= nil then
        editList[#editList + 1] = {address = targetAddr - 0x40, flags = gg.TYPE_DOUBLE, value = newSkin}
    end
    if newAttack then
        editList[#editList + 1] = {address = targetAddr - 0x20, flags = gg.TYPE_DOUBLE, value = newAttack} 
        editList[#editList + 1] = {address = targetAddr + 0x30, flags = gg.TYPE_DOUBLE, value = newDefense} 
        editList[#editList + 1] = {address = targetAddr - 0xC0, flags = gg.TYPE_DOUBLE, value = newSpeed} 
        editList[#editList + 1] = {address = targetAddr - 0x10, flags = gg.TYPE_DOUBLE, value = newJump} 
        editList[#editList + 1] = {address = targetAddr - 0x70, flags = gg.TYPE_DOUBLE, value = newAsc} 
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

--Pilihan char menu
function charMenu()
    gg.setVisible(false)
    local menuTitle = "CHARACTER MENU [" .. tostring(USER_NAME) .. "] - " .. tostring(MEMORY_NAME)
    
    local menu = gg.choice ({
    	"Siwoo",
        "Ohjun",
        "Jaejo",
        "Scan Character",
        "Kembali"
    }, nil, menuTitle)
    
    if menu == 1 then
        quickScanChar("Siwoo")
    elseif menu == 2 then
        quickScanChar("Ohjun")
    elseif menu == 3 then
        quickScanChar("Jaeho")
    elseif menu == 4 then
        menuEditCharacter()
    elseif menu == 5 then
        menuUtama()
    end
end

--MENU UTAMA
function menuUtama()
    gg.setVisible(false)
    local menuTitle = "Hanzz_TSC [" .. tostring(USER_NAME) .. "] - " .. tostring(MEMORY_NAME)

    local menu = gg.choice({
        "Character Menu",
        "Mastery Menu",
        "Config Skill All Character",
        "Gameplay Menu",
        "Show FPS Mode",
        "Menu UID",
        "Setup Memory",
        "Exit"
    }, nil, menuTitle)

    if menu == 1 then
        charMenu()
    elseif menu == 2 then
        masteryMenu()
    elseif menu == 3 then
        menuPilihKarakter()
    elseif menu == 4 then
        gameplayMenu()
    elseif menu == 5 then
        showFpsMode()
    elseif menu == 6 then
        menuUID()
    elseif menu == 7 then
        pilihMemory()
    elseif menu == 8 then
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