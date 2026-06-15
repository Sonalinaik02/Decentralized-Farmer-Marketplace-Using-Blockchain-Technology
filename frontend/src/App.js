import React, { useState } from "react";
import { ethers } from "ethers";
import ABI from "./MarketplaceABI.json";

const CONTRACT_ADDRESS = "YOUR_DEPLOYED_CONTRACT_ADDRESS";

function App() {
  const [name, setName] = useState("");
  const [price, setPrice] = useState("");
  const [quantity, setQuantity] = useState("");

  async function getContract() {
    if (!window.ethereum) return;
    const provider = new ethers.providers.Web3Provider(window.ethereum);
    const signer = provider.getSigner();
    return new ethers.Contract(CONTRACT_ADDRESS, ABI, signer);
  }

  async function listProduct() {
    const contract = await getContract();
    const tx = await contract.listProduct(name, parseInt(price), parseInt(quantity));
    await tx.wait();
    alert("Product listed successfully!");
  }

  return (
    <div className="p-6">
      <h1 className="text-2xl font-bold">Farmer Marketplace</h1>
      <div className="mt-4">
        <input placeholder="Name" value={name} onChange={(e) => setName(e.target.value)} />
        <input placeholder="Price (INR)" value={price} onChange={(e) => setPrice(e.target.value)} />
        <input placeholder="Quantity" value={quantity} onChange={(e) => setQuantity(e.target.value)} />
        <button onClick={listProduct}>List Product</button>
      </div>
    </div>
  );
}

export default App;
