// ────────────────
// 📦 Split manual des chunks
// ────────────────
print("📦 Étape 1 : Split des chunks...");

sh.splitAt("airbnbShard.logementsParisLyon", { host_location: "Lyon, France" });
sh.splitAt("airbnbShard.logementsParisLyon", { host_location: "Paris, France" });

// ────────────────
// 🚚 Move des chunks vers les shards
// ────────────────
print("🚚 Étape 2 : Déplacement des chunks...");

sh.moveChunk("airbnbShard.logementsParisLyon", { host_location: "Paris, France" }, "shard1Repl");
sh.moveChunk("airbnbShard.logementsParisLyon", { host_location: "Lyon, France" }, "shard2Repl");

// ────────────────
// 🔍 Vérification
// ────────────────
print("🔍 Étape 3 : Statut du cluster :");
sh.status();
