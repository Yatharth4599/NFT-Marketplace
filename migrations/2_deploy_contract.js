const FootballTicketNFT = artifacts.require("FootballTicketNFT");

module.exports = function (deployer) {
  const baseURI = "https://example.com/";
  deployer.deploy(FootballTicketNFT, baseURI);
};
