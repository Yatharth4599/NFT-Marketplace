import React, { useState } from "react";
import QRCode from "qrcode.react";
import FootballTicketNFT from "./FootballTicketNFT.json";
import Web3 from "web3";

const web3 = new Web3("http://localhost:7545");

function App() {
  const [qrData, setQRData] = useState("");

  const handleBuyTicket = async () => {
    try {
      const accounts = await web3.eth.getAccounts();
      const networkId = 5777;
      const deployedNetwork = FootballTicketNFT.networks[networkId];
      if (!deployedNetwork) {
        throw new Error(`Contract not deployed on network with id ${networkId}`);
      }
      const nftContract = new web3.eth.Contract(
        FootballTicketNFT.abi,
        deployedNetwork.address
      );
      const receipt = await nftContract.methods.createTicket(accounts[0], web3.utils.toWei("1"), "myTicketMetadata").send({ from: accounts[0], gas: 300000 });
      const tokenId = receipt.events.Transfer.returnValues.tokenId;
      const result = await nftContract.methods.generateQRCode(tokenId).call();
      setQRData(result);
    } catch (error) {
      console.error(error);
      alert("There was an error buying the ticket");
    }
  };

  
  
  return (
    <div>
      <h1>Generate QR Code for NFT</h1>
      <button onClick={handleBuyTicket}>Buy Ticket</button>
      {qrData && <QRCode value={qrData} />}
    </div>
  );
}

export default App;
