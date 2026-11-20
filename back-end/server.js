const express = require("express");
const cors = require("cors");
const pkg = require("pg");
const dotenv = require("dotenv");
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const fs = require("fs");
const readline = require("readline");
const { execSync } = require("child_process");

dotenv.config();

const app = express();
app.use(express.json());
app.use(cors());
