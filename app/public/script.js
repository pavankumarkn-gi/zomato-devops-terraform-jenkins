const restaurants = [
  { id: 1, name: "Hyderabadi Biryani Hub", cuisine: "Biryani, North Indian", price: 350, rating: 4.4, image: "https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=500" },
  { id: 2, name: "Pizza Corner Express", cuisine: "Italian, Fast Food", price: 299, rating: 4.2, image: "https://images.unsplash.com/photo-1513104890138-7c749659a591?w=500" },
  { id: 3, name: "Burger Castle", cuisine: "Burgers, Beverages", price: 199, rating: 4.1, image: "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=500" },
  { id: 4, name: "Royal Tandoori Corner", cuisine: "Mughlai, Kebabs", price: 420, rating: 4.5, image: "https://images.unsplash.com/photo-1599488615731-7e5c2823ff28?w=500" }
];

let cart = [];

function renderRestaurants(items) {
  const grid = document.getElementById("restaurantGrid");
  grid.innerHTML = items.map(r => `
    <div class="card">
      <img src="${r.image}" alt="${r.name}">
      <div class="card-content">
        <div class="card-title">
          <span>${r.name}</span>
          <span class="rating">★ ${r.rating}</span>
        </div>
        <div class="cuisine">${r.cuisine}</div>
        <div class="price-tag">₹${r.price} for one</div>
        <button class="btn" onclick="addToCart(${r.id})">Add to Cart</button>
      </div>
    </div>
  `).join('');
}

function addToCart(id) {
  const item = restaurants.find(r => r.id === id);
  if (item) {
    cart.push(item);
    renderCart();
  }
}

function renderCart() {
  const cartBox = document.getElementById("cartItems");
  const emptyMsg = document.getElementById("emptyCartMsg");
  const totalBox = document.getElementById("cartTotal");

  if (cart.length === 0) {
    emptyMsg.style.display = "block";
    cartBox.innerHTML = "";
    totalBox.innerHTML = "";
    return;
  }

  emptyMsg.style.display = "none";
  cartBox.innerHTML = cart.map((item, idx) => `
    <li class="cart-item">
      <span>${item.name}</span>
      <span>₹${item.price}</span>
    </li>
  `).join('');

  const total = cart.reduce((acc, curr) => acc + curr.price, 0);
  totalBox.innerHTML = `Grand Total: ₹${total}`;
}

document.getElementById("searchInput").addEventListener("input", (e) => {
  const val = e.target.value.toLowerCase();
  const filtered = restaurants.filter(r => 
    r.name.toLowerCase().includes(val) || r.cuisine.toLowerCase().includes(val)
  );
  renderRestaurants(filtered);
});

renderRestaurants(restaurants);
