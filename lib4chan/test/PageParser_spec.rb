require 'lib/4chan.rb'
require 'stringio'

# Publicise methods

module FourChan
	PageParser2 = PageParser
	PPGSP = PPGS
end

describe FourChan do
	it "Should provide a means to parse documents." do

		describe FourChan::PageParser2 do

			it "Should parse documents into managable structures using a supplied grammar" do

				doc = StringIO.new <<-"EOF"
					<html>
						<body>
							<div class="post">
								<span class="email">dave@gmail.com</span>
								<pre class="message">
									hello world
								</pre>
							</div>
							<div class="post">
								<span class="email">gibson@gmail.com</span>
								<pre class="message">
									goodbye cruel world
								</pre>
							</div>
						</body>
					</html>
				EOF

				grammar = FourChan::PPGSP.new('Root', {
					'/html/body/div.post' => FourChan::PPGSP.new('Posts', {
						'.email' => 'email',
						'.message' => 'post'
					})
				})

				expected = {
					'Posts' => [
						{
							'Email' => ['email_one'],
							'Post' => ['message_one']
						},
						{
							'Email' => ['email_two'],
							'Post' => []
						},
					]
				}

				parsed = FourChan::PageParser2.parse doc, grammar

				parsed.should equal(expected)

			end
		end
	end
end

# eg.
#
#	'Root' : {
#		'/html/body/div.post' => 'Posts' : {
#			'span.email' => 'Email',
#			'pre.message' => 'Post'
#		}
#	}
#
#	run on
#
#	<html>
#		<body>
#			<div class="post">
#				<span class="email">
#					email_one
#				<pre class="message">
#					message_one
#			<div class="post">
#				<span class="email">
#					email_two
#	...
#
#	Should produce the output:
#
#	{
#		'Posts' => [
#			{
#				'Email' => ['email_one'],
#				'Post' => ['message_one']
#			},
#			{
#				'Email' => ['email_two'],
#				'Post' => []
#			},
#		]
#	}
