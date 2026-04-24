import { esClient } from '../config/elasticsearch.js';

const MEDICINE_INDEX = 'medicines';

export const searchService = {
  async indexMedicine(medicine) {
    return esClient.index({
      index: MEDICINE_INDEX,
      id: medicine.id,
      document: {
        name: medicine.name,
        salt: medicine.salt,
        brand: medicine.brand,
        price: medicine.price,
        stock: medicine.stock,
        category: medicine.category,
        tags: medicine.tags,
      }
    });
  },

  async searchMedicines(query, limit = 20) {
    const result = await esClient.search({
      index: MEDICINE_INDEX,
      body: {
        size: limit,
        query: {
          multi_match: {
            query,
            fields: ['name^3', 'salt^2', 'brand', 'tags'],
            fuzziness: 'AUTO'
          }
        }
      }
    });

    return result.hits.hits.map(hit => ({
      id: hit._id,
      ...hit._source
    }));
  }
};
