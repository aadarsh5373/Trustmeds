import { query } from '../config/db.js';

export const searchService = {
  async searchMedicines(searchTerm) {
    try {
      // Fallback to PostgreSQL ILIKE for search if ES is not available
      const { rows } = await query(
        `SELECT * FROM medicines 
         WHERE name ILIKE $1 OR brand ILIKE $1 OR composition ILIKE $1 
         LIMIT 20`,
        [`%${searchTerm}%`]
      );
      
      return rows;
    } catch (error) {
      console.error('Search failed:', error);
      return [];
    }
  },

  async indexMedicine(medicine) {
    // This would typically sync with Elasticsearch
    console.log('Indexing medicine for search:', medicine.name);
  }
};
