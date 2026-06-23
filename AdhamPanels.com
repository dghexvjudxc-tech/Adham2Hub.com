<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ADHAM_panelX28 | لوحة التحكم</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Cairo:wght@400;600;700;800;900&display=swap');
        
        :root {
            --bg1: #0a0014; --bg2: #1a0030; --bg3: #0d0018;
            --gold: #FFD700; --gold2: #b8960f; --accent: #FFD700; --accent2: #fbbf24;
            --glow: rgba(255,215,0,0.5);
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Cairo', sans-serif;
            background: linear-gradient(135deg, var(--bg1) 0%, var(--bg2) 50%, var(--bg3) 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 15px;
            position: relative;
            overflow-x: hidden;
            transition: all 0.5s ease;
            cursor: default;
        }

        /* ========== مؤثرات الخلفية ========== */
        .bg-particles {
            position: fixed; top: 0; left: 0; width: 100%; height: 100%;
            pointer-events: none; z-index: 0;
        }

        .floating-orb {
            position: absolute; border-radius: 50%; filter: blur(60px); opacity: 0.3;
            animation: orbFloat 8s infinite ease-in-out;
        }
        @keyframes orbFloat {
            0%, 100% { transform: translate(0, 0) scale(1); }
            25% { transform: translate(100px, -50px) scale(1.3); }
            50% { transform: translate(-50px, -100px) scale(0.8); }
            75% { transform: translate(-100px, 50px) scale(1.2); }
        }

        .spark {
            position: absolute; width: 3px; height: 3px; background: var(--accent);
            border-radius: 50%; animation: sparkle 3s infinite;
            box-shadow: 0 0 8px var(--accent), 0 0 16px var(--accent2);
        }
        @keyframes sparkle {
            0%, 100% { opacity: 0; transform: scale(0); }
            50% { opacity: 1; transform: scale(1); }
        }

        .ripple {
            position: fixed; border-radius: 50%; border: 1px solid var(--accent);
            pointer-events: none; z-index: 999; animation: rippleOut 1s ease-out forwards;
            opacity: 0;
        }
        @keyframes rippleOut {
            0% { width: 0; height: 0; opacity: 1; }
            100% { width: 200px; height: 200px; opacity: 0; margin-left: -100px; margin-top: -100px; }
        }

        .click-particle {
            position: fixed; pointer-events: none; z-index: 999;
            animation: clickBurst 0.6s ease-out forwards;
            font-size: 20px;
        }
        @keyframes clickBurst {
            0% { transform: translate(0,0) scale(1); opacity: 1; }
            100% { transform: translate(var(--dx), var(--dy)) scale(0); opacity: 0; }
        }

        .container { position: relative; z-index: 1; width: 100%; max-width: 1300px; }

        .card {
            background: rgba(15, 3, 30, 0.92);
            backdrop-filter: blur(25px);
            border: 1px solid rgba(255, 215, 0, 0.35);
            border-radius: 28px;
            padding: 30px 25px;
            box-shadow: 0 0 60px rgba(255, 215, 0, 0.12), 0 0 100px rgba(255, 215, 0, 0.05);
            display: none;
            animation: cardIn 0.5s cubic-bezier(0.16, 1, 0.3, 1);
            transition: all 0.3s ease;
        }
        .card.show { display: block; }
        .card:hover {
            box-shadow: 0 0 80px rgba(255, 215, 0, 0.2), 0 0 120px rgba(255, 215, 0, 0.08);
            border-color: rgba(255, 215, 0, 0.5);
        }

        @keyframes cardIn {
            from { opacity: 0; transform: translateY(30px) scale(0.95); filter: blur(10px); }
            to { opacity: 1; transform: translateY(0) scale(1); filter: blur(0); }
        }

        .logo-box {
            width: 90px; height: 90px;
            background: rgba(255, 215, 0, 0.08);
            border: 2px solid var(--accent);
            border-radius: 24px;
            display: flex; align-items: center; justify-content: center;
            margin: 0 auto 18px;
            box-shadow: 0 0 40px var(--glow);
            animation: logoGlow 2s infinite alternate;
            transition: all 0.3s ease;
            cursor: pointer;
        }
        .logo-box:hover { transform: scale(1.1) rotate(5deg); box-shadow: 0 0 60px var(--glow); }
        .logo-box:active { transform: scale(0.95); }
        @keyframes logoGlow {
            0% { box-shadow: 0 0 30px var(--glow); }
            100% { box-shadow: 0 0 60px var(--glow); }
        }
        .logo-box i { font-size: 44px; color: var(--accent); filter: drop-shadow(0 0 15px var(--accent)); animation: iconPulse 1s infinite alternate; }
        @keyframes iconPulse {
            0% { transform: scale(1); }
            100% { transform: scale(1.1); }
        }

        .main-title { text-align: center; font-size: 32px; font-weight: 900; color: var(--accent); text-shadow: 0 0 25px var(--glow); }
        .sub-title { text-align: center; color: var(--accent2); font-size: 12px; letter-spacing: 6px; margin-bottom: 22px; }

        .db-bar {
            background: rgba(0,0,0,0.5); border: 1px solid rgba(255,215,0,0.2);
            border-radius: 50px; padding: 10px 20px; text-align: center;
            color: var(--accent); font-size: 12px; margin-bottom: 22px;
            transition: all 0.5s ease;
        }
        .db-bar.ok { border-color: #22c55e; color: #22c55e; animation: pulse 2s infinite; }
        @keyframes pulse {
            0%, 100% { box-shadow: 0 0 0 rgba(34,197,94,0); }
            50% { box-shadow: 0 0 20px rgba(34,197,94,0.5); }
        }

        .err-msg { color: #ef4444; text-align: center; font-size: 13px; min-height: 20px; }

        .input-group { position: relative; margin-bottom: 16px; }
        .input-group i {
            position: absolute; right: 16px; top: 50%; transform: translateY(-50%);
            color: var(--accent); font-size: 17px; transition: 0.3s;
        }
        .input-group input {
            width: 100%; padding: 14px 48px 14px 15px;
            background: rgba(0,0,0,0.55); border: 2px solid rgba(255,215,0,0.3);
            border-radius: 50px; color: #fff; font-size: 14px;
            font-family: 'Cairo', sans-serif; outline: none;
            transition: all 0.3s ease;
        }
        .input-group input:focus {
            border-color: var(--accent);
            box-shadow: 0 0 25px var(--glow);
            transform: scale(1.02);
        }

        .btn-gold {
            width: 100%; padding: 15px;
            background: linear-gradient(135deg, var(--gold2), var(--accent), var(--gold2));
            border: none; border-radius: 50px; color: #000;
            font-size: 16px; font-weight: 800; cursor: pointer;
            font-family: 'Cairo', sans-serif; margin-bottom: 14px;
            position: relative; overflow: hidden;
            transition: all 0.3s ease;
        }
        .btn-gold:hover {
            box-shadow: 0 0 40px var(--glow);
            transform: translateY(-3px);
        }
        .btn-gold:active {
            transform: scale(0.96);
            box-shadow: 0 0 20px var(--glow);
        }
        .btn-gold::after {
            content: ''; position: absolute; top: -50%; left: -50%; width: 200%; height: 200%;
            background: linear-gradient(45deg, transparent, rgba(255,255,255,0.4), transparent);
            animation: shine 3s infinite;
        }
        @keyframes shine {
            0% { transform: translateX(-100%) rotate(45deg); }
            100% { transform: translateX(100%) rotate(45deg); }
        }

        .btn-outline {
            width: 100%; padding: 12px; border-radius: 50px;
            border: 2px solid var(--accent); background: transparent; color: var(--accent);
            font-size: 14px; font-weight: 700; cursor: pointer;
            font-family: 'Cairo', sans-serif; transition: 0.3s;
        }
        .btn-outline:hover { background: rgba(255,215,0,0.15); box-shadow: 0 0 20px var(--glow); }

        .footer-note { text-align: center; color: rgba(255,215,0,0.5); font-size: 10px; margin-top: 15px; }
        .tg-link { color: #22d3ee; font-weight: 700; transition: 0.3s; }
        .tg-link:hover { text-shadow: 0 0 15px #22d3ee; }

        /* لوحة الأدمن */
        .top-bar {
            display: flex; align-items: center; justify-content: space-between;
            flex-wrap: wrap; gap: 12px; margin-bottom: 20px;
            padding: 12px 18px; background: rgba(0,0,0,0.6);
            border: 1px solid rgba(255,215,0,0.3); border-radius: 18px;
        }
        .top-bar .user-info { display: flex; align-items: center; gap: 10px; }
        .top-bar .avatar {
            width: 42px; height: 42px; background: linear-gradient(135deg, var(--gold2), var(--accent));
            border-radius: 50%; display: flex; align-items: center; justify-content: center;
            font-weight: 900; color: #000;
        }
        .top-bar .details .name { font-weight: 700; color: var(--accent); font-size: 15px; }
        .top-bar .details .id { font-size: 10px; color: rgba(255,215,0,0.5); }
        .balance-tag {
            background: rgba(255,215,0,0.1); border: 1px solid var(--accent);
            border-radius: 50px; padding: 7px 18px; color: var(--accent); font-weight: 700;
        }
        .theme-btn {
            padding: 8px 14px; border-radius: 50px; border: 1px solid var(--accent);
            background: rgba(0,0,0,0.5); color: var(--accent); cursor: pointer;
            font-family: 'Cairo', sans-serif; font-size: 11px; font-weight: 700;
            transition: 0.3s;
        }
        .theme-btn:hover { background: rgba(255,215,0,0.2); box-shadow: 0 0 15px var(--glow); }

        .theme-panel {
            display: none; position: absolute; top: 60px; left: 10px;
            background: rgba(10,3,25,0.98); border: 1px solid var(--accent);
            border-radius: 15px; padding: 15px; z-index: 100;
            width: 260px; box-shadow: 0 0 30px rgba(0,0,0,0.8);
        }
        .theme-panel.show { display: block; }
        .theme-panel h4 { color: var(--accent); margin-bottom: 10px; font-size: 13px; }
        .theme-colors { display: flex; flex-wrap: wrap; gap: 8px; }
        .theme-dot {
            width: 35px; height: 35px; border-radius: 50%; cursor: pointer;
            border: 2px solid transparent; transition: 0.3s;
        }
        .theme-dot:hover { transform: scale(1.2); border-color: #fff; }
        .theme-dot.active { border-color: #fff; box-shadow: 0 0 20px currentColor; }

        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(130px, 1fr)); gap: 12px; margin-bottom: 25px; }
        .stat-card {
            background: rgba(0,0,0,0.45); border: 1px solid rgba(255,215,0,0.25);
            border-radius: 16px; padding: 18px 12px; text-align: center;
            transition: 0.3s; cursor: pointer;
        }
        .stat-card:hover { border-color: var(--accent); box-shadow: 0 0 25px var(--glow); transform: translateY(-3px); }
        .stat-card i { font-size: 26px; color: var(--accent); margin-bottom: 5px; }
        .stat-card .num { font-size: 26px; font-weight: 900; color: var(--accent); }
        .stat-card .lbl { color: rgba(255,215,0,0.55); font-size: 10px; }

        .section-title { color: var(--accent); font-size: 16px; margin-bottom: 10px; }

        .table-wrap { overflow-x: auto; border: 1px solid rgba(255,215,0,0.2); border-radius: 14px; margin-bottom: 20px; }
        table { width: 100%; border-collapse: collapse; min-width: 750px; }
        th {
            background: rgba(255,215,0,0.1); padding: 10px; text-align: right;
            color: var(--accent); font-weight: 700; font-size: 11px;
            border-bottom: 2px solid rgba(255,215,0,0.3);
        }
        td { padding: 10px; border-bottom: 1px solid rgba(255,255,255,0.04); color: #fff; font-size: 12px; transition: 0.2s; }
        tr:hover td { background: rgba(255,215,0,0.04); }
        .text-gold { color: var(--accent); font-weight: 700; }
        .text-purple { color: #c084fc; font-weight: 700; }

        .action-btns { display: flex; gap: 5px; }
        .btn-xs {
            padding: 5px 8px; border: none; border-radius: 50px; color: #000;
            font-weight: 800; cursor: pointer; font-size: 9px; font-family: 'Cairo', sans-serif;
            background: var(--gold2); transition: 0.2s;
        }
        .btn-xs:hover { transform: scale(1.1); }
        .btn-xs:active { transform: scale(0.9); }

        .tools-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 14px; margin-bottom: 22px; }
        .tool-card {
            background: rgba(0,0,0,0.45); border: 1px solid rgba(255,215,0,0.25);
            border-radius: 16px; padding: 18px; transition: 0.3s;
        }
        .tool-card:hover { border-color: rgba(255,215,0,0.5); box-shadow: 0 0 20px rgba(255,215,0,0.1); }
        .tool-card h4 { color: var(--accent); margin-bottom: 10px; font-size: 13px; }

        .tool-input, .tool-select {
            width: 100%; padding: 9px 12px; border-radius: 50px;
            border: 2px solid rgba(255,215,0,0.3); background: rgba(0,0,0,0.5);
            color: #fff; font-family: 'Cairo', sans-serif; font-size: 12px;
            outline: none; margin-bottom: 7px; transition: 0.3s;
        }
        .tool-input:focus, .tool-select:focus { border-color: var(--accent); box-shadow: 0 0 15px var(--glow); }

        .btn-sm {
            padding: 9px 18px; background: linear-gradient(135deg, var(--gold2), var(--accent));
            border: none; border-radius: 50px; color: #000; font-weight: 800;
            cursor: pointer; font-family: 'Cairo', sans-serif; font-size: 12px;
            transition: 0.3s;
        }
        .btn-sm:hover { box-shadow: 0 0 20px var(--glow); transform: translateY(-2px); }
        .btn-sm:active { transform: scale(0.95); }
        .btn-sm.full { width: 100%; }

        .console-box {
            background: #000; border: 1px solid rgba(255,215,0,0.3);
            border-radius: 12px; padding: 14px; height: 130px; overflow-y: auto;
            font-family: 'Courier New', monospace; color: var(--accent); font-size: 11px;
            direction: ltr; text-align: left;
        }

        .modal {
            display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%;
            background: rgba(0,0,0,0.9); z-index: 1000;
            align-items: center; justify-content: center;
        }
        .modal.show { display: flex; }
        .modal-content {
            background: rgba(20, 5, 40, 0.98); border: 2px solid var(--accent);
            border-radius: 20px; padding: 30px; text-align: center;
            max-width: 450px; width: 90%;
            box-shadow: 0 0 80px var(--glow);
            animation: bounceIn 0.6s cubic-bezier(0.16, 1, 0.3, 1);
        }
        @keyframes bounceIn {
            0% { transform: scale(0.3); opacity: 0; }
            50% { transform: scale(1.05); }
            70% { transform: scale(0.95); }
            100% { transform: scale(1); opacity: 1; }
        }
        .code-display {
            background: #000; border: 2px dashed var(--accent);
            border-radius: 15px; padding: 20px;
            font-size: 26px; font-weight: 900; color: var(--accent);
            letter-spacing: 2px; margin: 15px 0;
            font-family: 'Courier New', monospace;
            text-shadow: 0 0 20px var(--accent);
        }

        @media (max-width: 768px) {
            .card { padding: 20px 14px; }
            .main-title { font-size: 24px; }
            .stats-grid { grid-template-columns: repeat(2, 1fr); }
        }
    </style>
</head>
<body>

<!-- خلفية متحركة -->
<div class="bg-particles" id="bgParticles"></div>

<div class="container">

    <!-- صفحة تسجيل الدخول -->
    <div class="card show" id="loginPage">
        <div class="logo-box" id="logoBox"><i class="fas fa-crown"></i></div>
        <h1 class="main-title">ADHAM_panelX28</h1>
        <p class="sub-title">DASHBOARD 2026 ✦</p>
        <div class="db-bar" id="dbBar"><span>⌛</span> جاري الاتصال بقاعدة البيانات...</div>
        <div class="err-msg" id="errMsg"></div>
        <div class="input-group"><i class="fas fa-user"></i><input type="text" id="userInput" placeholder="الآيدي أو اسم المستخدم"></div>
        <div class="input-group"><i class="fas fa-lock"></i><input type="password" id="passInput" placeholder="كلمة المرور"></div>
        <button class="btn-gold" id="loginBtn"><i class="fas fa-sign-in-alt"></i> ➔ تسجيل الدخول</button>
        <button class="btn-outline" id="showRegisterBtn"><i class="fas fa-user-plus"></i> إنشاء حساب جديد</button>
        <div class="footer-note">للشحن: <a href="https://t.me/azlo_2" class="tg-link">@azlo_2</a> | <span style="color:var(--accent);">ADHAM_panelX28</span></div>
    </div>

    <!-- صفحة إنشاء حساب -->
    <div class="card" id="registerPage">
        <div class="logo-box"><i class="fas fa-user-plus"></i></div>
        <h1 class="main-title">إنشاء حساب</h1>
        <div class="err-msg" id="regErrMsg"></div>
        <div class="input-group"><i class="fas fa-user"></i><input type="text" id="regName" placeholder="الاسم"></div>
        <div class="input-group"><i class="fas fa-lock"></i><input type="password" id="regPass" placeholder="كلمة المرور (4 أحرف على الأقل)"></div>
        <button class="btn-gold" id="registerBtn"><i class="fas fa-check"></i> إنشاء الحساب</button>
        <button class="btn-outline" id="backToLoginBtn">العودة لتسجيل الدخول</button>
    </div>

    <!-- لوحة الأدمن -->
    <div class="card" id="adminPage" style="position:relative;">
        <div class="top-bar">
            <div class="user-info"><div class="avatar" id="adminAvatar">A</div><div class="details"><div class="name" id="adminTopName">-</div><div class="id" id="adminTopId">-</div></div></div>
            <div style="display:flex;align-items:center;gap:10px;flex-wrap:wrap;">
                <div class="balance-tag">💰 $<span id="adminTopBalance">0</span></div>
                <button class="theme-btn" id="themeToggleBtn"><i class="fas fa-palette"></i> 🎨 الثيمات</button>
            </div>
        </div>

        <div class="theme-panel" id="themePanel">
            <h4><i class="fas fa-palette"></i> اختر الثيم:</h4>
            <div class="theme-colors">
                <div class="theme-dot active" style="background:#FFD700;" data-theme="gold" title="ذهبي"></div>
                <div class="theme-dot" style="background:#ef4444;" data-theme="red" title="أحمر"></div>
                <div class="theme-dot" style="background:#3b82f6;" data-theme="blue" title="أزرق"></div>
                <div class="theme-dot" style="background:#8b5cf6;" data-theme="purple" title="بنفسجي"></div>
                <div class="theme-dot" style="background:#22c55e;" data-theme="green" title="أخضر"></div>
                <div class="theme-dot" style="background:#06b6d4;" data-theme="cyan" title="سماوي"></div>
                <div class="theme-dot" style="background:#f59e0b;" data-theme="orange" title="برتقالي"></div>
                <div class="theme-dot" style="background:#ec4899;" data-theme="pink" title="وردي"></div>
                <div class="theme-dot" style="background:#ffffff;" data-theme="white" title="أبيض"></div>
                <div class="theme-dot" style="background:#78716c;" data-theme="brown" title="بني"></div>
            </div>
        </div>

        <div style="text-align:center;margin-bottom:15px;padding:8px;background:rgba(6,182,212,0.1);border:1px solid rgba(6,182,212,0.3);border-radius:50px;">
            <i class="fab fa-telegram"></i> للشحن: <a href="https://t.me/azlo_2" class="tg-link">@azlo_2</a>
        </div>

        <div class="stats-grid">
            <div class="stat-card"><i class="fas fa-store"></i><div class="num" id="resellerCount">0</div><div class="lbl">موزع</div></div>
            <div class="stat-card"><i class="fas fa-key"></i><div class="num" id="keyCount">0</div><div class="lbl">كود متاح</div></div>
            <div class="stat-card"><i class="fas fa-crown"></i><div class="num" id="adminCount">0</div><div class="lbl">أدمن</div></div>
            <div class="stat-card"><i class="fas fa-shopping-cart"></i><div class="num" id="soldCount">0</div><div class="lbl">مباع</div></div>
        </div>

        <h3 class="section-title"><i class="fas fa-user-tie"></i> قائمة الموزعين</h3>
        <div class="table-wrap">
            <table>
                <thead><tr><th>الآيدي</th><th>الاسم</th><th>الرصيد</th><th>الأكواد</th><th>الرتبة</th><th>إجراءات</th></tr></thead>
                <tbody id="resellerBody"></tbody>
            </table>
        </div>

        <div class="tools-grid">
            <div class="tool-card">
                <h4><i class="fas fa-plus-circle"></i> إضافة كود</h4>
                <select class="tool-select" id="codeProduct"><option value="">اختر المنتج</option></select>
                <input type="text" class="tool-input" id="newCodeInput" placeholder="الكود">
                <input type="text" class="tool-input" id="newCodeDuration" placeholder="المدة">
                <button class="btn-sm full" id="addCodeBtn">➕ إضافة الكود</button>
            </div>
            <div class="tool-card">
                <h4><i class="fas fa-crown"></i> تعيين / إزالة أدمن</h4>
                <input type="text" class="tool-input" id="setAdminId" placeholder="آيدي الموزع">
                <button class="btn-sm full" id="setAdminBtn" style="background:#7c3aed;">👑 تعيين كأدمن</button>
                <button class="btn-sm full" id="removeAdminBtn" style="background:#dc2626;">⬇️ إزالة الأدمن</button>
            </div>
            <div class="tool-card">
                <h4><i class="fas fa-paper-plane"></i> إرسال رصيد</h4>
                <input type="text" class="tool-input" id="sendIdInput" placeholder="آيدي الموزع">
                <input type="number" class="tool-input" id="sendAmountInput" placeholder="المبلغ $">
                <button class="btn-sm full" id="sendBalanceBtn">💵 إرسال الرصيد</button>
            </div>
            <div class="tool-card">
                <h4><i class="fas fa-shopping-cart"></i> شراء كود</h4>
                <input type="text" class="tool-input" id="buyResellerId" placeholder="آيدي الموزع">
                <select class="tool-select" id="buyCodeSelect"><option value="">اختر الكود المتاح</option></select>
                <button class="btn-sm full" id="buyCodeBtn" style="background:#d97706;">🛒 شراء الكود</button>
            </div>
        </div>

        <h3 class="section-title"><i class="fas fa-terminal"></i> سجل النظام</h3>
        <div class="console-box" id="consoleBox">
            <div><span style="color:#888;">[النظام]</span> جاهز - ADHAM_panelX28</div>
        </div>
    </div>

    <!-- نافذة الشراء -->
    <div class="modal" id="codeModal">
        <div class="modal-content">
            <h3 style="color:var(--accent);"><i class="fas fa-trophy"></i> 🎉 مبروك! تم الشراء</h3>
            <div id="modalProduct" style="color:var(--accent2);font-size:14px;"></div>
            <div class="code-display" id="modalCode">CODE</div>
            <div id="modalDuration" style="color:rgba(255,215,0,0.7);font-size:13px;"></div>
            <button class="btn-gold" id="closeModal">✅ حسناً</button>
        </div>
    </div>

</div>

<script>
// ==================== مؤثرات الخلفية ====================
const bgParticles = document.getElementById('bgParticles');

// كرات عائمة
for (let i = 0; i < 4; i++) {
    const orb = document.createElement('div');
    orb.classList.add('floating-orb');
    orb.style.width = (150 + Math.random() * 200) + 'px';
    orb.style.height = orb.style.width;
    orb.style.background = i % 2 === 0 ? 'var(--accent)' : '#a855f7';
    orb.style.left = Math.random() * 80 + '%';
    orb.style.top = Math.random() * 80 + '%';
    orb.style.animationDelay = i * 2 + 's';
    orb.style.animationDuration = (6 + Math.random() * 6) + 's';
    bgParticles.appendChild(orb);
}

// شرارات
for (let i = 0; i < 50; i++) {
    const spark = document.createElement('div');
    spark.classList.add('spark');
    spark.style.left = Math.random() * 100 + '%';
    spark.style.top = Math.random() * 100 + '%';
    spark.style.animationDelay = Math.random() * 3 + 's';
    spark.style.animationDuration = (2 + Math.random() * 3) + 's';
    bgParticles.appendChild(spark);
}

// ==================== مؤثرات تفاعلية (لمس/نقر) ====================
document.addEventListener('click', function(e) {
    // تأثير التموج
    const ripple = document.createElement('div');
    ripple.classList.add('ripple');
    ripple.style.left = e.clientX + 'px';
    ripple.style.top = e.clientY + 'px';
    document.body.appendChild(ripple);
    setTimeout(() => ripple.remove(), 1000);

    // جسيمات متناثرة
    const emojis = ['✨', '💫', '⭐', '🌟', '💛', '🔥', '💎', '🎯'];
    for (let i = 0; i < 5; i++) {
        const p = document.createElement('div');
        p.classList.add('click-particle');
        p.textContent = emojis[Math.floor(Math.random() * emojis.length)];
        p.style.left = e.clientX + 'px';
        p.style.top = e.clientY + 'px';
        p.style.setProperty('--dx', (Math.random() * 60 - 30) + 'px');
        p.style.setProperty('--dy', (Math.random() * 60 - 30) + 'px');
        document.body.appendChild(p);
        setTimeout(() => p.remove(), 600);
    }
});

// تأثير لمس على الموبايل
document.addEventListener('touchstart', function(e) {
    const touch = e.touches[0];
    const ripple = document.createElement('div');
    ripple.classList.add('ripple');
    ripple.style.left = touch.clientX + 'px';
    ripple.style.top = touch.clientY + 'px';
    document.body.appendChild(ripple);
    setTimeout(() => ripple.remove(), 1000);
});

// ==================== نظام الصوت ====================
let bgMusic = null;
let musicStarted = false;

function startBgMusic() {
    if (musicStarted) return;
    try {
        const ctx = new (window.AudioContext || window.webkitAudioContext)();
        
        function playNote(freq, startTime, duration, vol) {
            const osc = ctx.createOscillator();
            const gain = ctx.createGain();
            osc.connect(gain); gain.connect(ctx.destination);
            osc.frequency.value = freq;
            osc.type = 'sine';
            gain.gain.setValueAtTime(vol, startTime);
            gain.gain.exponentialRampToValueAtTime(0.001, startTime + duration);
            osc.start(startTime); osc.stop(startTime + duration);
        }

        // لحن هادئ
        const melody = [
            262, 330, 392, 523, 392, 330, 262, 294,
            330, 392, 440, 392, 330, 294, 262, 330
        ];
        
        melody.forEach((freq, i) => {
            playNote(freq, ctx.currentTime + i * 0.5, 0.4, 0.08);
        });
        
        // تكرار كل فترة
        bgMusic = setInterval(() => {
            melody.forEach((freq, i) => {
                playNote(freq, ctx.currentTime + i * 0.5, 0.4, 0.06);
            });
        }, melody.length * 500 + 2000);
        
        musicStarted = true;
    } catch(e) {}
}

function stopBgMusic() {
    if (bgMusic) { clearInterval(bgMusic); bgMusic = null; musicStarted = false; }
}

function playWinSound() {
    try {
        const ctx = new (window.AudioContext || window.webkitAudioContext)();
        
        // نغمات احتفالية سريعة
        const winNotes = [
            { freq: 523, time: 0, dur: 0.12 },
            { freq: 659, time: 0.1, dur: 0.12 },
            { freq: 784, time: 0.2, dur: 0.12 },
            { freq: 1047, time: 0.3, dur: 0.4 },
            { freq: 784, time: 0.5, dur: 0.12 },
            { freq: 1047, time: 0.6, dur: 0.6 }
        ];
        
        winNotes.forEach(n => {
            const osc = ctx.createOscillator();
            const gain = ctx.createGain();
            osc.connect(gain); gain.connect(ctx.destination);
            osc.frequency.value = n.freq;
            osc.type = 'triangle';
            gain.gain.setValueAtTime(0.35, ctx.currentTime + n.time);
            gain.gain.exponentialRampToValueAtTime(0.001, ctx.currentTime + n.time + n.dur);
            osc.start(ctx.currentTime + n.time);
            osc.stop(ctx.currentTime + n.time + n.dur);
        });
    } catch(e) {}
}

// تشغيل الموسيقى الهادئة عند أول تفاعل
document.addEventListener('click', function initMusic() {
    startBgMusic();
}, { once: true });

document.addEventListener('touchstart', function initMusicTouch() {
    startBgMusic();
}, { once: true });

// ==================== الثيمات ====================
const themes = {
    gold: { bg1: '#0a0014', bg2: '#1a0030', bg3: '#0d0018', gold: '#FFD700', gold2: '#b8960f', accent: '#FFD700', accent2: '#fbbf24', glow: 'rgba(255,215,0,0.5)' },
    red: { bg1: '#1a0000', bg2: '#300000', bg3: '#180000', gold: '#ef4444', gold2: '#dc2626', accent: '#ef4444', accent2: '#fca5a5', glow: 'rgba(239,68,68,0.5)' },
    blue: { bg1: '#00101a', bg2: '#002030', bg3: '#000d18', gold: '#3b82f6', gold2: '#2563eb', accent: '#3b82f6', accent2: '#93c5fd', glow: 'rgba(59,130,246,0.5)' },
    purple: { bg1: '#0a0020', bg2: '#1a0040', bg3: '#0d0028', gold: '#8b5cf6', gold2: '#7c3aed', accent: '#8b5cf6', accent2: '#c4b5fd', glow: 'rgba(139,92,246,0.5)' },
    green: { bg1: '#001a00', bg2: '#003000', bg3: '#001800', gold: '#22c55e', gold2: '#16a34a', accent: '#22c55e', accent2: '#86efac', glow: 'rgba(34,197,94,0.5)' },
    cyan: { bg1: '#001a1a', bg2: '#003030', bg3: '#001818', gold: '#06b6d4', gold2: '#0891b2', accent: '#06b6d4', accent2: '#67e8f9', glow: 'rgba(6,182,212,0.5)' },
    orange: { bg1: '#1a0a00', bg2: '#301a00', bg3: '#180d00', gold: '#f59e0b', gold2: '#d97706', accent: '#f59e0b', accent2: '#fcd34d', glow: 'rgba(245,158,11,0.5)' },
    pink: { bg1: '#1a0010', bg2: '#300020', bg3: '#180018', gold: '#ec4899', gold2: '#db2777', accent: '#ec4899', accent2: '#f9a8d4', glow: 'rgba(236,72,153,0.5)' },
    white: { bg1: '#111111', bg2: '#222222', bg3: '#111111', gold: '#ffffff', gold2: '#cccccc', accent: '#ffffff', accent2: '#ffffff', glow: 'rgba(255,255,255,0.5)' },
    brown: { bg1: '#1a1000', bg2: '#302010', bg3: '#181008', gold: '#78716c', gold2: '#57534e', accent: '#a8a29e', accent2: '#d6d3d1', glow: 'rgba(168,162,158,0.5)' }
};

let currentTheme = 'gold';

function applyTheme(name) {
    const t = themes[name]; if (!t) return;
    currentTheme = name;
    const r = document.documentElement;
    Object.entries(t).forEach(([k, v]) => r.style.setProperty('--' + k, v));
    document.body.style.background = `linear-gradient(135deg, ${t.bg1} 0%, ${t.bg2} 50%, ${t.bg3} 100%)`;
    document.querySelectorAll('.theme-dot').forEach(d => d.classList.remove('active'));
    const ad = document.querySelector(`.theme-dot[data-theme="${name}"]`);
    if (ad) ad.classList.add('active');
    localStorage.setItem('adham_theme', name);
}

applyTheme(localStorage.getItem('adham_theme') || 'gold');

document.getElementById('themeToggleBtn').addEventListener('click', (e) => {
    e.stopPropagation();
    document.getElementById('themePanel').classList.toggle('show');
});
document.addEventListener('click', () => document.getElementById('themePanel').classList.remove('show'));
document.querySelectorAll('.theme-dot').forEach(d => {
    d.addEventListener('click', (e) => { e.stopPropagation(); applyTheme(d.dataset.theme); document.getElementById('themePanel').classList.remove('show'); });
});

// ==================== البيانات ====================
const products = [
    'Drip Client ApkMod', 'HG Cheats ApkMod+Root', 'PatoTeam Orange ApkMod',
    'PatoTeam Blue ApkMod', 'PatoTeam Green ApkMod', 'Prime Hook ApkMod+Root',
    'PROXY DRIP FF MOBILE', 'BrMods RootDevice', 'Drip Client RootDevice',
    'Flourite FF IOS', 'TM Panel', 'PXT PANEL'
];

let resellers = [], codes = [], adminIds = ['3081913640'];
let codeNum = 1, currentId = null;

function generateUniqueId() {
    let id;
    do { id = String(Math.floor(1000000000 + Math.random() * 9000000000)); }
    while (resellers.find(r => r.id === id) || adminIds.includes(id));
    return id;
}

const loginPage = document.getElementById('loginPage');
const registerPage = document.getElementById('registerPage');
const adminPage = document.getElementById('adminPage');

function show(p) {
    [loginPage, registerPage, adminPage].forEach(x => x.classList.remove('show'));
    p.classList.add('show');
}

setTimeout(() => {
    document.getElementById('dbBar').classList.add('ok');
    document.getElementById('dbBar').innerHTML = '<span>✅</span> تم الاتصال بقاعدة البيانات';
}, 800);

// ==================== إنشاء حساب ====================
document.getElementById('showRegisterBtn').addEventListener('click', () => show(registerPage));
document.getElementById('backToLoginBtn').addEventListener('click', () => show(loginPage));

document.getElementById('registerBtn').addEventListener('click', () => {
    const n = document.getElementById('regName').value.trim();
    const p = document.getElementById('regPass').value.trim();
    if (!n || !p) { document.getElementById('regErrMsg').textContent = '⚠️ كامل البيانات'; return; }
    if (p.length < 4) { document.getElementById('regErrMsg').textContent = '⚠️ 4 أحرف على الأقل'; return; }
    const id = generateUniqueId();
    resellers.push({ id, name: n, balance: 0, date: new Date().toISOString().split('T')[0], active: true, codes: [], isAdmin: false, password: p });
    alert('✅ تم إنشاء الحساب!\nالآيدي: ' + id + '\nالاسم: ' + n);
    document.getElementById('regName').value = ''; document.getElementById('regPass').value = '';
    show(loginPage);
});

// ==================== تسجيل الدخول ====================
document.getElementById('loginBtn').addEventListener('click', () => {
    const u = document.getElementById('userInput').value.trim();
    const p = document.getElementById('passInput').value.trim();
    const r = resellers.find(x => (x.id === u || x.name === u) && x.password === p);
    if (r && adminIds.includes(r.id)) { currentId = r.id; updateTopBar(); renderAll(); show(adminPage); addLog('🔓 أدمن: ' + r.name); }
    else if (r) { alert('❌ ليس لديك صلاحية أدمن.\nللترقية: @azlo_2'); }
    else { document.getElementById('errMsg').textContent = '❌ بيانات غير صحيحة'; }
    document.getElementById('userInput').value = ''; document.getElementById('passInput').value = '';
});

function updateTopBar() {
    const r = resellers.find(x => x.id === currentId);
    if (!r) return;
    document.getElementById('adminTopName').textContent = r.name;
    document.getElementById('adminTopId').textContent = '#' + r.id;
    document.getElementById('adminTopBalance').textContent = r.balance;
    document.getElementById('adminAvatar').textContent = r.name.charAt(0);
}

function renderAll() {
    document.getElementById('codeProduct').innerHTML = '<option value="">اختر المنتج</option>' + products.map(p => `<option>${p}</option>`).join('');
    document.getElementById('buyCodeSelect').innerHTML = '<option value="">اختر الكود</option>' + codes.filter(c => c.status === 'متاح').map(c => `<option value="${c.number}">#${c.number} - ${c.productName} - ${c.duration}</option>`).join('');
    document.getElementById('resellerCount').textContent = resellers.length;
    document.getElementById('keyCount').textContent = codes.filter(c => c.status === 'متاح').length;
    document.getElementById('adminCount').textContent = adminIds.length;
    document.getElementById('soldCount').textContent = codes.filter(c => c.status === 'مباع').length;
    
    const tb = document.getElementById('resellerBody'); tb.innerHTML = '';
    if (resellers.length === 0) tb.innerHTML = '<tr><td colspan="6" style="text-align:center;padding:20px;">لا يوجد موزعين</td></tr>';
    else resellers.forEach(r => {
        const ia = adminIds.includes(r.id);
        tb.innerHTML += `<tr><td class="text-gold">${r.id}</td><td>${r.name}${ia?' <span class="text-purple">👑</span>':''}</td><td class="text-gold">$${r.balance}</td><td>${r.codes.length}</td><td class="${ia?'text-purple':''}">${ia?'أدمن':'موزع'}</td><td><div class="action-btns"><button class="btn-xs" onclick="viewCodes('${r.id}')">👁</button><button class="btn-xs" style="background:#7c3aed;" onclick="editReseller('${r.id}')">✏️</button><button class="btn-xs" style="background:#dc2626;" onclick="deleteReseller('${r.id}')">🗑</button></div></td></tr>`;
    });
}

function addLog(m) {
    const b = document.getElementById('consoleBox');
    b.innerHTML += `<div><span style="color:#888;">[${new Date().toLocaleTimeString('ar-SA')}]</span> ${m}</div>`;
    b.scrollTop = b.scrollHeight;
}

function viewCodes(id) {
    const r = resellers.find(x => x.id === id);
    if (!r || r.codes.length === 0) { alert('📭 لا توجد أكواد'); return; }
    let m = `📋 ${r.name}:\n━━━━━━\n`;
    r.codes.forEach((c, i) => { m += `📦 ${c.productName}\n🔑 ${c.code}\n⏱️ ${c.duration}\n`; if (i < r.codes.length - 1) m += '━━━━━━\n'; });
    alert(m);
}

function editReseller(id) {
    const r = resellers.find(x => x.id === id);
    if (!r) return;
    const nn = prompt('الاسم الجديد:', r.name);
    if (nn && nn.trim()) { r.name = nn.trim(); renderAll(); addLog('✏️ تعديل: ' + r.name); }
}

function deleteReseller(id) {
    if (id === '3081913640') { alert('❌ لا يمكن حذف الأدمن الأساسي'); return; }
    if (!confirm('متأكد؟')) return;
    const i = resellers.findIndex(x => x.id === id);
    if (i !== -1) { const n = resellers[i].name; resellers.splice(i, 1); adminIds = adminIds.filter(a => a !== id); renderAll(); addLog('🗑 حذف: ' + n); }
}

// ==================== إضافة كود ====================
document.getElementById('addCodeBtn').addEventListener('click', () => {
    const p = document.getElementById('codeProduct').value, c = document.getElementById('newCodeInput').value.trim(), d = document.getElementById('newCodeDuration').value.trim();
    if (!p || !c || !d) return;
    codes.push({ number: String(codeNum).padStart(3, '0'), productName: p, code: c, duration: d, status: 'متاح', buyer: '-' });
    codeNum++; renderAll(); addLog('➕ كود: ' + c);
    document.getElementById('newCodeInput').value = ''; document.getElementById('newCodeDuration').value = '';
});

// ==================== تعيين أدمن ====================
document.getElementById('setAdminBtn').addEventListener('click', () => {
    const id = document.getElementById('setAdminId').value.trim();
    const r = resellers.find(x => x.id === id);
    if (r && !adminIds.includes(id)) { adminIds.push(id); r.isAdmin = true; alert('✅ ' + r.name + ' أدمن الآن'); renderAll(); }
    else alert('غير موجود أو أدمن بالفعل');
});
document.getElementById('removeAdminBtn').addEventListener('click', () => {
    const id = document.getElementById('setAdminId').value.trim();
    if (id === '3081913640') return alert('❌ لا يمكن إزالة الأدمن الأساسي');
    if (adminIds.includes(id)) { adminIds = adminIds.filter(a => a !== id); const r = resellers.find(x => x.id === id); if (r) r.isAdmin = false; alert('تم إزالة الأدمن'); renderAll(); }
});

// ==================== إرسال رصيد ====================
document.getElementById('sendBalanceBtn').addEventListener('click', () => {
    const id = document.getElementById('sendIdInput').value.trim(), a = parseFloat(document.getElementById('sendAmountInput').value);
    const r = resellers.find(x => x.id === id);
    if (r && a > 0) { r.balance += a; addLog('💰 $' + a + ' → ' + r.name); renderAll(); }
});

// ==================== شراء كود ====================
document.getElementById('buyCodeBtn').addEventListener('click', () => {
    const rid = document.getElementById('buyResellerId').value.trim(), cn = document.getElementById('buyCodeSelect').value;
    const r = resellers.find(x => x.id === rid), c = codes.find(x => x.number === cn);
    if (!r || !c || c.status !== 'متاح') return;
    c.status = 'مباع'; c.buyer = r.name;
    r.codes.push({ productName: c.productName, code: c.code, duration: c.duration, date: new Date().toISOString().split('T')[0] });
    document.getElementById('modalProduct').textContent = '📦 ' + c.productName;
    document.getElementById('modalCode').textContent = c.code;
    document.getElementById('modalDuration').textContent = '⏱️ ' + c.duration + ' | 👤 ' + r.name;
    document.getElementById('codeModal').classList.add('show');
    playWinSound();
    addLog('🛒 ' + c.productName + ' → ' + r.name);
    renderAll();
});
document.getElementById('closeModal').addEventListener('click', () => document.getElementById('codeModal').classList.remove('show'));

// ==================== بدء ====================
if (!resellers.find(r => r.id === '3081913640')) {
    resellers.unshift({ id: '3081913640', name: 'ADHAM2', balance: 9999, date: '2026-01-01', active: true, codes: [], isAdmin: true, password: '30819111' });
}
if (!adminIds.includes('3081913640')) adminIds.push('3081913640');
addLog('✅ ADHAM_panelX28 جاهز');
addLog('🎵 موسيقى هادئة تعمل');
addLog('🎨 10 ثيمات متاحة');
renderAll();
</script>

</body>
</html>
