use anchor_lang::prelude::*;

/// Account context to invoke [deposit_for_burn_with_caller].
pub struct DepositForBurnWithCaller<'info> {
    /// Signer. This account must be the owner of `burn_token`.
    //#[account(signer)]
    pub burn_token_owner: AccountInfo<'info>,

    //#[account(mut, signer)]
    pub payer: AccountInfo<'info>,

    /// Seeds must be \["sender_authority"\] (CCTP Token Messenger Minter program).
    pub token_messenger_minter_sender_authority: AccountInfo<'info>,

    /// Mutable. This token account must be owned by `burn_token_owner`.
    //#[account(mut)]
    pub burn_token: AccountInfo<'info>,

    /// Mutable. Seeds must be \["message_transmitter"\] (CCTP Message Transmitter program).
    //#[account(mut)]
    pub message_transmitter_config: AccountInfo<'info>,

    /// Seeds must be \["token_messenger"\] (CCTP Token Messenger Minter program).
    pub token_messenger: AccountInfo<'info>,

    /// Seeds must be \["remote_token_messenger"\, remote_domain.to_string()] (CCTP Token Messenger
    /// Minter program).
    pub remote_token_messenger: AccountInfo<'info>,

    /// Seeds must be \["token_minter"\] (CCTP Token Messenger Minter program).
    pub token_minter: AccountInfo<'info>,

    /// Mutable. Seeds must be \["local_token", mint\] (CCTP Token Messenger Minter program).
    //#[account(mut)]
    pub local_token: AccountInfo<'info>,

    /// Mutable. Mint to be burned via CCTP.
    //#[account(mut)]
    pub mint: AccountInfo<'info>,

    //#[account(mut, signer)]
    pub cctp_message: AccountInfo<'info>,

    /// CCTP Message Transmitter program.
    pub message_transmitter_program: AccountInfo<'info>,

    /// CCTP Token Messenger Minter program.
    pub token_messenger_minter_program: AccountInfo<'info>,

    pub token_program: AccountInfo<'info>,

    pub system_program: AccountInfo<'info>,

    /// Seeds must be \["__event_authority"\] (CCTP Token Messenger Minter program).
    pub event_authority: AccountInfo<'info>,
}

/// Parameters to invoke [deposit_for_burn_with_caller].
#[derive(Clone, AnchorSerialize, AnchorDeserialize)]
pub struct DepositForBurnWithCallerParams {
    /// Transfer (burn) amount.
    pub amount: u64,

    /// CCTP domain value of the token to be transferred.
    pub destination_domain: u32,

    /// Recipient of assets on target network.
    ///
    /// NOTE: In the Token Messenger Minter program IDL, this is encoded as a Pubkey, which is
    /// weird because this address is one for another network. We are making it a 32-byte fixed
    /// array instead.
    pub mint_recipient: [u8; 32],

    /// Expected caller on target network.
    ///
    /// NOTE: In the Token Messenger Minter program IDL, this is encoded as a Pubkey, which is
    /// weird because this address is one for another network. We are making it a 32-byte fixed
    /// array instead.
    pub destination_caller: [u8; 32],
}

/// CPI call to invoke the CCTP Token Messenger Minter program to burn Circle-supported assets.
///
/// NOTE: This instruction requires specifying a specific caller on the destination network. Only
/// this caller can mint tokens on behalf of the
/// [mint_recipient](DepositForBurnWithCallerParams::mint_recipient).
pub fn deposit_for_burn_with_caller<'info>(
    ctx: CpiContext<'_, '_, '_, 'info, DepositForBurnWithCaller<'info>>,
    args: DepositForBurnWithCallerParams,
) -> Result<()> {
    const ANCHOR_IX_SELECTOR: [u8; 8] = [167, 222, 19, 114, 85, 21, 14, 118];

    solana_program::program::invoke_signed(
        &solana_program::instruction::Instruction {
            program_id: crate::cctp::TOKEN_MESSENGER_MINTER_PROGRAM_ID,
            accounts: ctx.to_account_metas(None),
            data: (ANCHOR_IX_SELECTOR, args).try_to_vec()?,
        },
        &ctx.to_account_infos(),
        ctx.signer_seeds,
    )
    .map_err(Into::into)
}

impl<'info> ToAccountMetas for DepositForBurnWithCaller<'info> {
    fn to_account_metas(&self, _is_signer: Option<bool>) -> Vec<AccountMeta> {
        vec![
            AccountMeta::new_readonly(self.burn_token_owner.key(), true),
            AccountMeta::new(self.payer.key(), true),
            AccountMeta::new_readonly(self.token_messenger_minter_sender_authority.key(), false),
            AccountMeta::new(self.burn_token.key(), false),
            AccountMeta::new(self.message_transmitter_config.key(), false),
            AccountMeta::new_readonly(self.token_messenger.key(), false),
            AccountMeta::new_readonly(self.remote_token_messenger.key(), false),
            AccountMeta::new_readonly(self.token_minter.key(), false),
            AccountMeta::new(self.local_token.key(), false),
            AccountMeta::new(self.mint.key(), false),
            AccountMeta::new(self.cctp_message.key(), true),
            AccountMeta::new_readonly(self.message_transmitter_program.key(), false),
            AccountMeta::new_readonly(self.token_messenger_minter_program.key(), false),
            AccountMeta::new_readonly(self.token_program.key(), false),
            AccountMeta::new_readonly(self.system_program.key(), false),
            AccountMeta::new_readonly(self.event_authority.key(), false),
            AccountMeta::new_readonly(self.token_messenger_minter_program.key(), false),
        ]
    }
}

impl<'info> ToAccountInfos<'info> for DepositForBurnWithCaller<'info> {
    fn to_account_infos(&self) -> Vec<AccountInfo<'info>> {
        vec![
            self.burn_token_owner.clone(),
            self.payer.clone(),
            self.token_messenger_minter_sender_authority.clone(),
            self.burn_token.clone(),
            self.message_transmitter_config.clone(),
            self.token_messenger.clone(),
            self.remote_token_messenger.clone(),
            self.token_minter.clone(),
            self.local_token.clone(),
            self.mint.clone(),
            self.cctp_message.clone(),
            self.message_transmitter_program.clone(),
            self.token_program.clone(),
            self.system_program.clone(),
            self.event_authority.clone(),
        ]
    }
}
