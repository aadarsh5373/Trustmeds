import '../../features/medicines/models/medicine_model.dart';
import '../../features/lab_tests/models/lab_test_model.dart';
import '../../features/doctor_consult/models/doctor_model.dart';
import '../../features/health_records/models/health_record_model.dart';

class MockDataService {
  static List<MedicineModel> getMedicines() {
    return [
      MedicineModel(id: 'm1', name: 'Dolo 650mg', brand: 'Micro Labs', category: 'Pain Relief', genericName: 'Paracetamol', mrp: 35, sellingPrice: 28, discount: 20, composition: 'Paracetamol 650mg', uses: 'Used to treat fever, headache, and mild to moderate pain.', sideEffects: 'Nausea, allergic reactions (rare)', dosage: '1 tablet every 4-6 hours as needed', manufacturer: 'Micro Labs Ltd', rating: 4.5, reviewCount: 2340, tags: ['fever', 'pain', 'headache']),
      MedicineModel(id: 'm2', name: 'Azithral 500mg', brand: 'Alembic', category: 'Antibiotics', genericName: 'Azithromycin', mrp: 120, sellingPrice: 96, discount: 20, requiresPrescription: true, composition: 'Azithromycin 500mg', uses: 'Treats bacterial infections of the respiratory tract, skin, and ear.', manufacturer: 'Alembic Pharmaceuticals', rating: 4.3, reviewCount: 1856, tags: ['antibiotic', 'infection']),
      MedicineModel(id: 'm3', name: 'Pan 40mg', brand: 'Alkem', category: 'Digestive', genericName: 'Pantoprazole', mrp: 85, sellingPrice: 62, discount: 27, composition: 'Pantoprazole 40mg', uses: 'Used to treat acidity, acid reflux, and peptic ulcers.', manufacturer: 'Alkem Laboratories', rating: 4.4, reviewCount: 3120, tags: ['acidity', 'gastric']),
      MedicineModel(id: 'm4', name: 'Shelcal 500mg', brand: 'Torrent', category: 'Vitamins', genericName: 'Calcium + Vitamin D3', mrp: 152, sellingPrice: 121, discount: 20, composition: 'Calcium Carbonate 1250mg, Vitamin D3 250 IU', uses: 'Calcium supplement for bone health.', manufacturer: 'Torrent Pharmaceuticals', rating: 4.6, reviewCount: 4200, tags: ['calcium', 'bones', 'vitamin']),
      MedicineModel(id: 'm5', name: 'Crocin Advance', brand: 'GSK', category: 'Pain Relief', genericName: 'Paracetamol', mrp: 30, sellingPrice: 25, discount: 17, composition: 'Paracetamol 500mg', uses: 'Fast relief from headache, toothache, body pain, and fever.', manufacturer: 'GlaxoSmithKline', rating: 4.4, reviewCount: 5600, tags: ['fever', 'pain', 'headache']),
      MedicineModel(id: 'm6', name: 'Becosules Capsule', brand: 'Pfizer', category: 'Vitamins', genericName: 'Multivitamin', mrp: 32, sellingPrice: 26, discount: 19, composition: 'Vitamin B Complex with Vitamin C', uses: 'Helps in treating vitamin B complex and vitamin C deficiency.', manufacturer: 'Pfizer Ltd', rating: 4.5, reviewCount: 7800, tags: ['vitamin', 'immunity']),
      MedicineModel(id: 'm7', name: 'Allegra 120mg', brand: 'Sanofi', category: 'Allergy', genericName: 'Fexofenadine', mrp: 170, sellingPrice: 136, discount: 20, composition: 'Fexofenadine Hydrochloride 120mg', uses: 'Relieves symptoms of allergic rhinitis and urticaria.', manufacturer: 'Sanofi India', rating: 4.3, reviewCount: 2100, tags: ['allergy', 'cold']),
      MedicineModel(id: 'm8', name: 'Volini Spray', brand: 'Sun Pharma', category: 'Pain Relief', genericName: 'Diclofenac', mrp: 220, sellingPrice: 187, discount: 15, composition: 'Diclofenac Diethylamine', uses: 'Topical pain relief for muscle and joint pain.', manufacturer: 'Sun Pharmaceutical', rating: 4.2, reviewCount: 3400, tags: ['pain', 'muscle', 'spray']),
      MedicineModel(id: 'm9', name: 'Zincovit Tablet', brand: 'Apex', category: 'Vitamins', genericName: 'Multivitamin + Zinc', mrp: 115, sellingPrice: 92, discount: 20, composition: 'Vitamins A, B, C, D, E, Zinc, Selenium', uses: 'Nutritional supplement for immunity and overall health.', manufacturer: 'Apex Laboratories', rating: 4.7, reviewCount: 9100, tags: ['vitamin', 'zinc', 'immunity']),
      MedicineModel(id: 'm10', name: 'Cetaphil Moisturizer', brand: 'Galderma', category: 'Skin Care', genericName: 'Moisturizing Cream', mrp: 350, sellingPrice: 298, discount: 15, composition: 'Cetearyl Alcohol, Glycerin', uses: 'Daily moisturizer for sensitive and dry skin.', manufacturer: 'Galderma India', rating: 4.6, reviewCount: 6300, tags: ['skin', 'moisturizer', 'cream']),
      MedicineModel(id: 'm11', name: 'Himalaya Liv.52', brand: 'Himalaya', category: 'Ayurveda', genericName: 'Liver Supplement', mrp: 130, sellingPrice: 104, discount: 20, composition: 'Himsra, Kasani extracts', uses: 'Protects the liver and improves its function.', manufacturer: 'Himalaya Wellness', rating: 4.5, reviewCount: 8500, tags: ['ayurveda', 'liver']),
      MedicineModel(id: 'm12', name: 'ORS Sachets', brand: 'Electral', category: 'Digestive', genericName: 'Oral Rehydration Salts', mrp: 22, sellingPrice: 18, discount: 18, composition: 'Sodium Chloride, Potassium Chloride, Dextrose', uses: 'Prevents and treats dehydration due to diarrhea.', manufacturer: 'FDC Limited', rating: 4.3, reviewCount: 4500, tags: ['hydration', 'diarrhea']),
    ];
  }

  static List<LabTestModel> getLabTests() {
    return [
      LabTestModel(id: 't1', name: 'Complete Blood Count (CBC)', description: 'Measures different components of blood including red blood cells, white blood cells, hemoglobin, and platelets.', price: 500, discountedPrice: 299, parameters: ['Hemoglobin', 'RBC Count', 'WBC Count', 'Platelet Count', 'PCV', 'MCV', 'MCH', 'MCHC'], reportTime: '6 hours', isPopular: true, category: 'Blood'),
      LabTestModel(id: 't2', name: 'Full Body Checkup', description: 'Comprehensive health screen covering 65+ parameters including liver, kidney, thyroid, diabetes, and lipid profile.', price: 2499, discountedPrice: 999, parameters: ['CBC', 'Liver Function', 'Kidney Function', 'Lipid Profile', 'Thyroid Profile', 'Blood Sugar', 'Urine Routine', 'Iron Studies'], reportTime: '24 hours', isPopular: true, category: 'Health Packages'),
      LabTestModel(id: 't3', name: 'Thyroid Profile (T3, T4, TSH)', description: 'Evaluates thyroid gland function by measuring thyroid hormones.', price: 800, discountedPrice: 449, parameters: ['T3 (Triiodothyronine)', 'T4 (Thyroxine)', 'TSH (Thyroid Stimulating Hormone)'], reportTime: '12 hours', isPopular: true, category: 'Thyroid'),
      LabTestModel(id: 't4', name: 'Lipid Profile', description: 'Measures cholesterol levels and risk for heart disease.', price: 600, discountedPrice: 349, parameters: ['Total Cholesterol', 'HDL', 'LDL', 'VLDL', 'Triglycerides', 'Total Cholesterol/HDL Ratio'], reportTime: '8 hours', isPopular: true, category: 'Heart'),
      LabTestModel(id: 't5', name: 'HbA1c (Glycated Hemoglobin)', description: 'Tracks average blood sugar level over the past 2-3 months.', price: 500, discountedPrice: 299, parameters: ['Glycated Hemoglobin (HbA1c)', 'Estimated Average Glucose'], reportTime: '6 hours', isPopular: true, category: 'Diabetes'),
      LabTestModel(id: 't6', name: 'Liver Function Test (LFT)', description: 'Evaluates liver health by measuring proteins, liver enzymes, and bilirubin.', price: 700, discountedPrice: 399, parameters: ['Bilirubin Total', 'Bilirubin Direct', 'SGOT', 'SGPT', 'Alkaline Phosphatase', 'Total Protein', 'Albumin', 'Globulin'], reportTime: '8 hours', category: 'Liver'),
      LabTestModel(id: 't7', name: 'Kidney Function Test (KFT)', description: 'Assesses how well kidneys are working.', price: 650, discountedPrice: 379, parameters: ['Blood Urea', 'Serum Creatinine', 'Uric Acid', 'BUN', 'Sodium', 'Potassium', 'Calcium', 'Phosphorus'], reportTime: '8 hours', category: 'Kidney'),
      LabTestModel(id: 't8', name: 'Vitamin D Test', description: 'Measures Vitamin D levels in the blood.', price: 900, discountedPrice: 499, parameters: ['25-Hydroxy Vitamin D'], reportTime: '12 hours', isPopular: true, category: 'Vitamins'),
    ];
  }

  static List<DoctorModel> getDoctors() {
    return [
      DoctorModel(id: 'd1', name: 'Dr. Priya Sharma', specialization: 'General Physician', qualification: 'MBBS, MD (Internal Medicine)', experience: 12, consultationFee: 499, rating: 4.8, reviewCount: 2340, languages: ['English', 'Hindi'], isAvailableNow: true, bio: 'Experienced General Physician with expertise in treating acute and chronic conditions. Special interest in preventive healthcare.'),
      DoctorModel(id: 'd2', name: 'Dr. Rajesh Kumar', specialization: 'Dermatologist', qualification: 'MBBS, MD (Dermatology)', experience: 15, consultationFee: 699, rating: 4.7, reviewCount: 1856, languages: ['English', 'Hindi', 'Punjabi'], isAvailableNow: true, bio: 'Board-certified dermatologist specializing in acne, eczema, psoriasis, and cosmetic dermatology.'),
      DoctorModel(id: 'd3', name: 'Dr. Sneha Patel', specialization: 'Pediatrician', qualification: 'MBBS, DCH, DNB (Pediatrics)', experience: 10, consultationFee: 549, rating: 4.9, reviewCount: 3200, languages: ['English', 'Hindi', 'Gujarati'], isAvailableNow: false, bio: 'Dedicated pediatrician with focus on newborn care, vaccinations, and child nutrition.'),
      DoctorModel(id: 'd4', name: 'Dr. Arun Mehta', specialization: 'Cardiologist', qualification: 'MBBS, MD, DM (Cardiology)', experience: 20, consultationFee: 999, rating: 4.9, reviewCount: 4100, languages: ['English', 'Hindi'], isAvailableNow: true, bio: 'Senior cardiologist with expertise in interventional cardiology and cardiac care management.'),
      DoctorModel(id: 'd5', name: 'Dr. Kavita Reddy', specialization: 'Gynecologist', qualification: 'MBBS, MS (OBG), DNB', experience: 14, consultationFee: 599, rating: 4.6, reviewCount: 2800, languages: ['English', 'Hindi', 'Telugu'], isAvailableNow: true, bio: 'Women\'s health specialist with expertise in pregnancy care, PCOS, and menstrual health.'),
      DoctorModel(id: 'd6', name: 'Dr. Vikram Singh', specialization: 'Orthopedic', qualification: 'MBBS, MS (Orthopedics)', experience: 18, consultationFee: 799, rating: 4.5, reviewCount: 1900, languages: ['English', 'Hindi'], isAvailableNow: false, bio: 'Orthopedic surgeon specializing in joint replacement, sports medicine, and spine disorders.'),
      DoctorModel(id: 'd7', name: 'Dr. Anita Desai', specialization: 'Neurologist', qualification: 'MBBS, MD, DM (Neurology)', experience: 16, consultationFee: 1200, rating: 4.8, reviewCount: 1540, languages: ['English', 'Hindi', 'Marathi'], isAvailableNow: true, bio: 'Expert in treating headaches, migraines, stroke, and nerve disorders.'),
      DoctorModel(id: 'd8', name: 'Dr. Rohan Gupta', specialization: 'Endocrinologist', qualification: 'MBBS, MD (Medicine), DM (Endocrinology)', experience: 11, consultationFee: 850, rating: 4.7, reviewCount: 980, languages: ['English', 'Hindi'], isAvailableNow: true, bio: 'Specializes in diabetes management, thyroid disorders, and hormonal imbalances.'),
    ];
  }

  static List<HealthRecordModel> getHealthRecords() {
    return [
      HealthRecordModel(id: 'r1', title: 'Annual Health Checkup Report', type: 'report', date: DateTime.now().subtract(const Duration(days: 30)), doctorName: 'Dr. Priya Sharma', notes: 'All parameters normal. Vitamin D slightly low.'),
      HealthRecordModel(id: 'r2', title: 'Prescription - Cold & Cough', type: 'prescription', date: DateTime.now().subtract(const Duration(days: 15)), doctorName: 'Dr. Rajesh Kumar', notes: 'Azithral 500mg for 3 days, Dolo 650 SOS'),
      HealthRecordModel(id: 'r3', title: 'COVID-19 Vaccination', type: 'vaccination', date: DateTime.now().subtract(const Duration(days: 180)), doctorName: 'PHC Center', notes: 'Covishield - Dose 2 completed'),
    ];
  }

  static List<Map<String, dynamic>> getCategories() {
    return [
      {'name': 'Pain Relief', 'icon': 'medication', 'color': '#FF6B9D'},
      {'name': 'Vitamins', 'icon': 'local_pharmacy', 'color': '#FF8FAB'},
      {'name': 'Digestive', 'icon': 'medical_services', 'color': '#E91E8C'},
      {'name': 'Skin Care', 'icon': 'spa', 'color': '#FFB3CC'},
      {'name': 'Antibiotics', 'icon': 'science', 'color': '#FF6B9D'},
      {'name': 'Ayurveda', 'icon': 'eco', 'color': '#4CAF82'},
      {'name': 'Allergy', 'icon': 'air', 'color': '#FFA726'},
      {'name': 'Diabetes', 'icon': 'monitor_heart', 'color': '#2196F3'},
      {'name': 'Baby Care', 'icon': 'child_care', 'color': '#FF8FAB'},
    ];
  }
}
