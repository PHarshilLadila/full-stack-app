import 'package:dart_frog/dart_frog.dart';

Response onRequest(RequestContext context) {
  return Response.json(body: {'message': 'API working'});
}



// #!/bin/bash

// BASE_URL="http://localhost:8080"

// echo "=== 1. Login as Seller (ID: 6a0420603505347547f4a2e7) ==="
// SELLER_TOKEN=$(curl -s -X POST $BASE_URL/auth/login \
//   -H "Content-Type: application/json" \
//   -d '{"email":"seller@example.com","password":"password123"}' \
//   | jq -r '.token')

// echo "Seller Token: ${SELLER_TOKEN:0:50}..."

// echo -e "\n=== 2. Add a product as this seller ==="
// PRODUCT_RESPONSE=$(curl -s -X POST $BASE_URL/product/add \
//   -H "Authorization: Bearer $SELLER_TOKEN" \
//   -H "Content-Type: application/json" \
//   -d '{
//     "productName": "Test Product for Order",
//     "price": 999,
//     "stock": 100,
//     "category": "Test",
//     "subCategory": "Test Category",
//     "shortDescription": "This is a test product",
//     "detailedDescription": "Detailed description here",
//     "mainBannerImage": "https://example.com/image.jpg"
//   }')

// echo "Product Response: $PRODUCT_RESPONSE"
// PRODUCT_ID=$(echo $PRODUCT_RESPONSE | jq -r '.data.productId')
// echo "Product ID: $PRODUCT_ID"

// echo -e "\n=== 3. Login as Customer ==="
// CUSTOMER_TOKEN=$(curl -s -X POST $BASE_URL/auth/login \
//   -H "Content-Type: application/json" \
//   -d '{"email":"customer@example.com","password":"password123"}' \
//   | jq -r '.token')

// echo "Customer Token: ${CUSTOMER_TOKEN:0:50}..."

// echo -e "\n=== 4. Add address for customer ==="
// ADDRESS_RESPONSE=$(curl -s -X POST $BASE_URL/address/add \
//   -H "Authorization: Bearer $CUSTOMER_TOKEN" \
//   -H "Content-Type: application/json" \
//   -d '{
//     "fullName": "Test Customer",
//     "mobileNumber": "9876543210",
//     "pincode": "110001",
//     "addressLine1": "123 Test Street",
//     "city": "New Delhi",
//     "state": "Delhi",
//     "isDefault": true
//   }')

// ADDRESS_ID=$(echo $ADDRESS_RESPONSE | jq -r '.data.addressId')
// echo "Address ID: $ADDRESS_ID"

// echo -e "\n=== 5. Add product to cart ==="
// curl -s -X POST $BASE_URL/cart/add \
//   -H "Authorization: Bearer $CUSTOMER_TOKEN" \
//   -H "Content-Type: application/json" \
//   -d "{
//     \"productId\": \"$PRODUCT_ID\",
//     \"quantity\": 1
//   }" | jq '.'

// echo -e "\n=== 6. Create order ==="
// ORDER_RESPONSE=$(curl -s -X POST $BASE_URL/order/create \
//   -H "Authorization: Bearer $CUSTOMER_TOKEN" \
//   -H "Content-Type: application/json" \
//   -d "{
//     \"addressId\": \"$ADDRESS_ID\",
//     \"paymentMethod\": \"cod\"
//   }")

// echo "Order Response: $ORDER_RESPONSE"
// NEW_ORDER_ID=$(echo $ORDER_RESPONSE | jq -r '.data.orderId')
// echo "New Order ID: $NEW_ORDER_ID"

// echo -e "\n=== 7. Update order status as Seller ==="
// curl -s -X PUT $BASE_URL/order/update_status \
//   -H "Authorization: Bearer $SELLER_TOKEN" \
//   -H "Content-Type: application/json" \
//   -d "{
//     \"orderId\": \"$NEW_ORDER_ID\",
//     \"orderStatus\": \"confirmed\"
//   }" | jq '.'

// echo -e "\n=== 8. Update to shipped with tracking ==="
// curl -s -X PUT $BASE_URL/order/update_status \
//   -H "Authorization: Bearer $SELLER_TOKEN" \
//   -H "Content-Type: application/json" \
//   -d "{
//     \"orderId\": \"$NEW_ORDER_ID\",
//     \"orderStatus\": \"shipped\",
//     \"trackingId\": \"TRK123456789\"
//   }" | jq '.'

// echo -e "\n=== 9. Update to delivered ==="
// curl -s -X PUT $BASE_URL/order/update_status \
//   -H "Authorization: Bearer $SELLER_TOKEN" \
//   -H "Content-Type: application/json" \
//   -d "{
//     \"orderId\": \"$NEW_ORDER_ID\",
//     \"orderStatus\": \"delivered\"
//   }" | jq '.'