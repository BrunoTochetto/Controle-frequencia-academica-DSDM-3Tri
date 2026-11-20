import express, { json } from "express";
import cors from "cors";
import pkg from "pg";
import { config } from "dotenv";

import jwt from "jsonwebtoken";

// Cadastrar turmas, estudantes e registrar presenças.

config();

const app = express();
app.use(json());
app.use(cors());





app.get("/api/status", (req, res) => {
  res.json({ message: "Status Ativo" });
});

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`Servidor rodando em http://localhost:${PORT}`));