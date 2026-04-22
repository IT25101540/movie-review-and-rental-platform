package com.movieplatform.util;

import java.io.*;
import java.nio.file.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Utility class for file-based data storage (flat-file CRUD).
 * Uses BufferedReader/BufferedWriter for reading and writing .txt files.
 * Each record is stored as one line, fields delimited by '|'.
 */
public class FileUtil {

    /**
     * Read all non-empty, non-comment lines from a file.
     *
     * @param filePath path to the data file
     * @return list of lines (never null)
     */
    public static List<String> readAllLines(String filePath) {
        List<String> lines = new ArrayList<>();
        File file = new File(filePath);

        // Create file if it doesn't exist
        if (!file.exists()) {
            try {
                file.getParentFile().mkdirs();
                file.createNewFile();
            } catch (IOException e) {
                e.printStackTrace();
            }
            return lines;
        }

        try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String trimmed = line.trim();
                // Skip empty lines and comments
                if (!trimmed.isEmpty() && !trimmed.startsWith("#")) {
                    lines.add(trimmed);
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return lines;
    }

    /**
     * Write all lines to a file (overwrites existing content).
     *
     * @param filePath path to the data file
     * @param lines    list of lines to write
     */
    public static void writeAllLines(String filePath, List<String> lines) {
        File file = new File(filePath);
        file.getParentFile().mkdirs();

        try (BufferedWriter writer = new BufferedWriter(new FileWriter(file))) {
            for (String line : lines) {
                writer.write(line);
                writer.newLine();
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * Append a single line to the end of a file.
     *
     * @param filePath path to the data file
     * @param line     the line to append
     */
    public static void appendLine(String filePath, String line) {
        File file = new File(filePath);
        file.getParentFile().mkdirs();

        try (BufferedWriter writer = new BufferedWriter(new FileWriter(file, true))) {
            writer.write(line);
            writer.newLine();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * Update a line whose first '|'-delimited field matches the given ID.
     *
     * @param filePath path to the data file
     * @param id       the ID to match (first field before '|')
     * @param newLine  the replacement line
     * @return true if a matching line was found and updated
     */
    public static boolean updateLine(String filePath, String id, String newLine) {
        List<String> lines = readAllLines(filePath);
        boolean found = false;

        for (int i = 0; i < lines.size(); i++) {
            String[] parts = lines.get(i).split("\\|");
            if (parts.length > 0 && parts[0].trim().equalsIgnoreCase(id)) {
                lines.set(i, newLine);
                found = true;
                break;
            }
        }

        if (found) {
            writeAllLines(filePath, lines);
        }
        return found;
    }

    /**
     * Delete a line whose first '|'-delimited field matches the given ID.
     *
     * @param filePath path to the data file
     * @param id       the ID to match (first field before '|')
     * @return true if a matching line was found and deleted
     */
    public static boolean deleteLine(String filePath, String id) {
        List<String> lines = readAllLines(filePath);
        boolean removed = lines.removeIf(line -> {
            String[] parts = line.split("\\|");
            return parts.length > 0 && parts[0].trim().equalsIgnoreCase(id);
        });

        if (removed) {
            writeAllLines(filePath, lines);
        }
        return removed;
    }

    /**
     * Find a line by its ID (first '|'-delimited field).
     *
     * @param filePath path to the data file
     * @param id       the ID to search for
     * @return the matching line, or null if not found
     */
    public static String findById(String filePath, String id) {
        List<String> lines = readAllLines(filePath);
        for (String line : lines) {
            String[] parts = line.split("\\|");
            if (parts.length > 0 && parts[0].trim().equalsIgnoreCase(id)) {
                return line;
            }
        }
        return null;
    }

    /**
     * Generate the next auto-increment ID based on a prefix.
     * Scans existing IDs and returns prefix + (max + 1), zero-padded to 3 digits.
     * e.g., prefix="U" with existing U001, U002 → returns "U003"
     *
     * @param filePath path to the data file
     * @param prefix   the ID prefix (e.g., "U", "M", "R", "RV")
     * @return the next ID string
     */
    public static String generateNextId(String filePath, String prefix) {
        List<String> lines = readAllLines(filePath);
        int maxNum = 0;

        for (String line : lines) {
            String[] parts = line.split("\\|");
            if (parts.length > 0) {
                String id = parts[0].trim();
                if (id.startsWith(prefix)) {
                    try {
                        int num = Integer.parseInt(id.substring(prefix.length()));
                        if (num > maxNum) {
                            maxNum = num;
                        }
                    } catch (NumberFormatException ignored) {
                    }
                }
            }
        }

        return prefix + String.format("%03d", maxNum + 1);
    }
}
