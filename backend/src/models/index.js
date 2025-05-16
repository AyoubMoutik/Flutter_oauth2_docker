import { Sequelize } from "sequelize";
import dotenv from "dotenv";

dotenv.config();

const dbUrl = process.env.DATABASE_URL;

export const sequelize = new Sequelize(dbUrl);

// Import model definitions
import { initializeUser } from "./user.js";

// Initialize models
const User = initializeUser(sequelize);

// Export models
export { User };

// Test database connection
export const testConnection = async () => {
    try {
        await sequelize.authenticate();
        console.log('Database connection established successfully.');
    } catch (error) {
        console.error('Unable to connect to the database:', error);
    }
};
