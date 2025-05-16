import { User } from "../models/index.js";

export const isAdmin = async (req, res, next) => {
    try {
        const user = await User.findOne({
            where: { id: req.user.id },
            attributes: ['isAdmin']
        });

        if (!user || !user.isAdmin) {
            return res.status(403).json({ msg: "Access denied. Admin privileges required." });
        }

        next();
    } catch (error) {
        console.error(error);
        return res.status(500).json({ msg: "Server error" });
    }
};