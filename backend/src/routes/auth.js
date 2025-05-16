import express from "express";
import jwt from "jsonwebtoken";
import { User } from "../models/index.js";
import { authenticateToken } from "../middleware/auth.js";
import { isAdmin } from "../middleware/admin.js";
import dotenv from "dotenv";

dotenv.config();

const router = express.Router();

// Register new user
router.post("/register", async (req, res) => {
  try {
    const { email, password, name, isAdmin } = req.body;
    const existingUser = await User.findOne({ where: { email } });

    if (existingUser) {
      return res.status(400).json({ msg: "User already exists" });
    }

    const user = await User.create({ email, password, name, isAdmin: isAdmin || false });
    return res.status(200).json({ msg: "User registered successfully" });
  } catch (error) {
    console.error(error);
    return res.status(400).json({ msg: "Registration failed" });
  }
});

// Login
router.post("/login", async (req, res) => {
  try {
    const { email, password } = req.body;
    const user = await User.findOne({
      where: { email },
      attributes: ['id', 'email', 'password', 'isAdmin']
    });

    if (!user || !(await user.validatePassword(password))) {
      return res.status(401).json({ msg: "Invalid credentials" });
    }

    const accessToken = jwt.sign(
      { id: user.id, email: user.email, isAdmin: user.isAdmin },
      process.env.JWT_SECRET,
      { expiresIn: "15m" }
    );

    const refreshToken = jwt.sign(
      { id: user.id, email: user.email, isAdmin: user.isAdmin },
      process.env.JWT_REFRESH_SECRET,
      { expiresIn: "7d" }
    );

    await user.update({ refreshToken });

    return res.json({
      access_token: accessToken,
      refresh_token: refreshToken,
      isAdmin: user.isAdmin
    });
  } catch (error) {
    console.error(error);
    return res.status(401).json({ msg: "Login failed" });
  }
});

// Admin route to get all users
router.get("/users", authenticateToken, isAdmin, async (req, res) => {
  try {
    const users = await User.findAll({
      attributes: ['id', 'name', 'email', 'isAdmin', 'createdAt'],
      order: [['createdAt', 'DESC']]
    });
    return res.json({ users });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ msg: "Failed to fetch users" });
  }
});

// Admin route to update user
router.put("/users/:id", authenticateToken, isAdmin, async (req, res) => {
  try {
    const { id } = req.params;
    const { email, name, isAdmin: newIsAdmin } = req.body;

    const user = await User.findByPk(id);

    if (!user) {
      return res.status(404).json({ msg: "User not found" });
    }

    // Don't allow admin to remove their own admin privileges
    if (req.user.id === id && !newIsAdmin) {
      return res.status(400).json({ msg: "Cannot remove your own admin privileges" });
    }

    await user.update({
      email: email || user.email,
      name: name || user.name,
      isAdmin: newIsAdmin !== undefined ? newIsAdmin : user.isAdmin
    });

    return res.json({
      msg: "User updated successfully",
      user: {
        id: user.id,
        name: user.name,
        email: user.email,
        isAdmin: user.isAdmin,
        createdAt: user.createdAt
      }
    });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ msg: "Failed to update user" });
  }
});

// Refresh token
router.post("/refresh-token", async (req, res) => {
  try {
    const { refresh_token } = req.body;

    if (!refresh_token) {
      return res.status(401).json({ msg: "Refresh token required" });
    }

    const user = await User.findOne({ where: { refreshToken: refresh_token } });

    if (!user) {
      return res.status(401).json({ msg: "Invalid refresh token" });
    }

    jwt.verify(refresh_token, process.env.JWT_REFRESH_SECRET, (err, decoded) => {
      if (err) {
        return res.status(401).json({ msg: "Invalid refresh token" });
      }

      const accessToken = jwt.sign(
        { id: user.id, email: user.email },
        process.env.JWT_SECRET,
        { expiresIn: "15m" }
      );

      const refreshToken = jwt.sign(
        { id: user.id, email: user.email },
        process.env.JWT_REFRESH_SECRET,
        { expiresIn: "7d" }
      );

      user.update({ refreshToken });

      return res.json({ access_token: accessToken, refresh_token: refreshToken });
    });
  } catch (error) {
    console.error(error);
    return res.status(401).json({ msg: "Token refresh failed" });
  }
});

// Protected route example
router.get("/protected", authenticateToken, async (req, res) => {
  try {
    const user = await User.findOne({
      where: { id: req.user.id },
      attributes: ['id', 'email', 'name'] // Only return safe fields
    });

    res.json({
      msg: "Successfully accessed protected route",
      user: user
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ msg: "Error accessing protected route" });
  }
});

export default router;
