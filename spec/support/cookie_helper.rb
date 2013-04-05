def cookie_jar
   Capybara.current_session.driver.browser.current_session.instance_variable_get(:@rack_mock_session).cookie_jar
end
