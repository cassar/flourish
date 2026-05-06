module StaticPagesHelper
  ACTIVITY_ICONS = {
    seed: { css: 'bg-base-300 text-primary',
            path: 'M12 22V14m0 0c-2 0-5-2-5-5a5 5 0 0 1 10 0c0 3-3 5-5 5z' },
    harvest: { css: 'bg-primary text-primary-content',
               path: 'M9.813 15.904 9 18.75l-.813-2.846a4.5 4.5 0 0 0-3.09-3.09' \
                     'L2.25 12l2.846-.813a4.5 4.5 0 0 0 3.09-3.09L9 5.25l.813 2.846' \
                     'a4.5 4.5 0 0 0 3.09 3.09L15.75 12l-2.846.813a4.5 4.5 0 0 0-3.09 3.09Z' },
    claim: { css: 'bg-secondary/20 text-secondary',
             path: 'M19.5 13.5 12 21m0 0-7.5-7.5M12 21V3' },
    reseed: { css: 'bg-accent/20 text-accent',
              path: 'M16.023 9.348h4.992v-.001M2.985 19.644v-4.992m0 0h4.992' \
                    'm-4.993 0 3.181 3.183a8.25 8.25 0 0 0 13.803-3.7' \
                    'M4.031 9.865a8.25 8.25 0 0 1 13.803-3.7l3.181 3.182m0-4.991v4.99' },
    generic: { css: 'bg-base-200 text-base-content/50',
               path: 'M12 9v3.75m9-.75a9 9 0 1 1-18 0 9 9 0 0 1 18 0Zm-9 3.75h.008v.008H12v-.008Z' }
  }.freeze

  ACTIVITY_LOG_PATTERNS = [
    [/Contribution of (\S+) received/, ->(m) { { text: 'Someone put in', amount: "+#{m[1]}", type: :seed } }],
    [/Distribution (#\d+) created/,
     ->(m) { { text: "Week #{m[1]} distributed to all members", amount: nil, type: :harvest } }],
    [/Payout requested/, ->(_) { { text: 'Someone received their share', amount: nil, type: :claim } }],
    [/recontributed/, ->(_) { { text: 'Someone recontributed', amount: nil, type: :reseed } }]
  ].freeze

  def parse_activity_log(message)
    ACTIVITY_LOG_PATTERNS.each do |pattern, builder|
      match = message.match(pattern)
      return builder.call(match) if match
    end
    { text: message.truncate(60), amount: nil, type: :generic }
  end

  def activity_icon(type)
    icon = ACTIVITY_ICONS.fetch(type, ACTIVITY_ICONS[:generic])
    content_tag(:div, class: "w-8 h-8 rounded-full #{icon[:css]} flex items-center justify-center shrink-0") do
      tag.svg(xmlns: 'http://www.w3.org/2000/svg', fill: 'none', viewBox: '0 0 24 24',
              stroke_width: '1.8', stroke: 'currentColor', class: 'w-4 h-4') do
        tag.path(stroke_linecap: 'round', stroke_linejoin: 'round', d: icon[:path])
      end
    end
  end
end
