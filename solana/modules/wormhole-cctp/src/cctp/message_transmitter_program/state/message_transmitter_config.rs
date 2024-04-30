use anchor_lang::prelude::*;

#[derive(Debug, AnchorSerialize, AnchorDeserialize, Clone)]
pub struct MessageTransmitterConfig {
    pub owner: Pubkey,
    pub pending_owner: Pubkey,
    pub attester_manager: Pubkey,
    pub pauser: Pubkey,
    pub paused: bool,
    pub local_domain: u32,
    pub version: u32,
    pub signature_threshold: u32,
    pub enabled_attesters: Vec<[u8; 32]>,
    pub max_message_body_size: u64,
    pub next_available_nonce: u64,
}

wormhole_solana_utils::impl_anchor_account_readonly!(
    MessageTransmitterConfig,
    crate::cctp::message_transmitter_program::ID,
    [71, 40, 180, 142, 19, 203, 35, 252]
);
