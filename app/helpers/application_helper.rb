# frozen_string_literal: true

module ApplicationHelper
  def full_title(page_title = '')
    base_title = 'Dungeons'
    if page_title.empty?
      base_title
    else
      page_title + ' | ' + base_title
    end
  end

  # returns boolean if whether current account matches given account
  def current_account?(account)
    account == current_account
  end
end
