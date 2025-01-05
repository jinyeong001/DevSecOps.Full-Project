document.addEventListener('DOMContentLoaded', function () {
    const init = () => {
        // 초기 화면 표시
        showInitialContent();
    }

    function showInitialContent() {
        // 모든 탭 패널 숨기기
        document.querySelectorAll('.tab-pane').forEach(pane => {
            pane.classList.remove('show', 'active');
        });
        // 초기 화면 표시
        document.getElementById('home-content').classList.add('show', 'active');
    }

    // 마크다운 파일 로드 및 표시 함수
    async function loadMarkdownContent(filename) {
        try {
            document.getElementById('home-content').classList.remove('show', 'active');
            const response = await fetch(`md/${filename}.md`);
            const text = await response.text();
            
            // marked 옵션 설정
            marked.setOptions({
                breaks: true,        // 줄바꿈 활성화
                gfm: true,          // GitHub Flavored Markdown 활성화
                pedantic: false,
                sanitize: false,
                smartLists: true,
                smartypants: false,
                xhtml: false
            });
            
            const htmlContent = marked.parse(text);
            document.getElementById('markdown-content').innerHTML = htmlContent;
            document.getElementById('main-list-item-1-content').classList.add('show', 'active');
            
            // 코드 블록에 하이라이팅 적용 (선택사항)
            document.querySelectorAll('pre code').forEach((block) => {
                hljs.highlightBlock(block);
            });
        } catch (error) {
            console.error('Error loading markdown file:', error);
            document.getElementById('markdown-content').innerHTML = 'Error loading content';
        }
    }

    // 목든 하위 목차 항목에 대한 클릭 이벤트 처리
    document.querySelectorAll('.table-of-contents .list-group-item').forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            
            // 텍스트에서 섹션 번호 추출 (예: "1-1. DevSecOps 란?" -> "1-1")
            const sectionMatch = this.textContent.match(/(\d+-\d+)/);
            if (sectionMatch) {
                const sectionNumber = sectionMatch[1];
                loadMarkdownContent(sectionNumber);
            }
            
            // 활성 상태 표시
            document.querySelectorAll('.table-of-contents .list-group-item').forEach(item => {
                item.classList.remove('active');
            });
            this.classList.add('active');
        });
    });

    // 메인 메뉴 아이템 클릭 이벤트
    const mainListItems = document.querySelectorAll('[id^="main-list-item-"]');
    mainListItems.forEach(item => {
        item.addEventListener('click', function() {
            const tocId = 'toc' + this.id.split('-').pop();
            
            // 다른 모든 목차 닫기
            document.querySelectorAll('.table-of-contents').forEach(toc => {
                if (toc.id !== tocId && toc.classList.contains('show')) {
                    const bsCollapse = bootstrap.Collapse.getInstance(toc);
                    if (bsCollapse) {
                        bsCollapse.hide();
                    }
                }
            });

            // 현재 목차 토글
            const tocElement = document.getElementById(tocId);
            if (tocElement) {
                const bsCollapse = new bootstrap.Collapse(tocElement, {
                    toggle: true
                });
            }
        });
    });

    // Navbar 링크 이벤트 처리
    document.getElementById('nav-home').addEventListener('click', function(e) {
        e.preventDefault();
        showInitialContent();
        
        // 활성 상태 표시
        document.querySelectorAll('.nav-link').forEach(link => {
            link.classList.remove('active');
        });
        this.classList.add('active');
    });

    document.getElementById('nav-introduction').addEventListener('click', async function(e) {
        e.preventDefault();
        try {
            // 초기 화면 숨기기
            document.getElementById('home-content').classList.remove('show', 'active');
            
            // introduction.md 로드
            const response = await fetch('md/introduction.md');
            const text = await response.text();
            const htmlContent = marked.parse(text);
            document.getElementById('markdown-content').innerHTML = htmlContent;
            document.getElementById('main-list-item-1-content').classList.add('show', 'active');
            
            // 활성 상태 표시
            document.querySelectorAll('.nav-link').forEach(link => {
                link.classList.remove('active');
            });
            this.classList.add('active');
        } catch (error) {
            console.error('Error loading introduction:', error);
        }
    });

    document.getElementById('nav-team').addEventListener('click', async function(e) {
        e.preventDefault();
        try {
            // 모든 탭 패널 숨기기
            document.querySelectorAll('.tab-pane').forEach(pane => {
                pane.classList.remove('show', 'active');
            });
            
            // markdown-content가 있는 패널 활성화
            document.getElementById('main-list-item-1-content').classList.add('show', 'active');
            
            // 마크다운 콘텐츠 로드
            const response = await fetch('md/team.md');
            const text = await response.text();
            const htmlContent = marked.parse(text);
            document.getElementById('markdown-content').innerHTML = htmlContent;
            
            // 활성 상태 표시
            document.querySelectorAll('.nav-link').forEach(link => {
                link.classList.remove('active');
            });
            this.classList.add('active');
        } catch (error) {
            console.error('Error loading team:', error);
        }
    });

    // 초기화 시 Home 버튼 활성화
    document.getElementById('nav-home').classList.add('active');

    // 코드 표시 기능 수정
    document.addEventListener('click', async function(e) {
        if (e.target.classList.contains('show-code')) {
            e.preventDefault();
            e.stopPropagation(); // 이벤트 전파 중단
            
            // 현재 열려있는 collapse 요소들을 유지하기 위해 강제로 show 클래스 추가
            document.querySelectorAll('.table-of-contents.show').forEach(toc => {
                toc.classList.add('show');
                // bootstrap collapse 인스턴스가 있다면 dispose
                const bsCollapse = bootstrap.Collapse.getInstance(toc);
                if (bsCollapse) {
                    bsCollapse.dispose();
                }
            });

            const codeFile = e.target.dataset.codeFile;
            try {
                const response = await fetch(`code/${codeFile}.md`);
                const text = await response.text();
                
                marked.setOptions({
                    highlight: function(code, lang) {
                        return hljs.highlightAuto(code).value;
                    }
                });
                
                const htmlContent = marked.parse(text);
                
                const codeContent = document.getElementById('code-content');
                codeContent.innerHTML = htmlContent;
                codeContent.classList.remove('d-none');
                
                document.querySelectorAll('#code-content pre code').forEach((block) => {
                    hljs.highlightBlock(block);
                });
            } catch (error) {
                console.error('Error loading code:', error);
            }
        }
    });

    // 코드 창 닫기 기능 수정
    document.addEventListener('click', function(e) {
        if (e.target.classList.contains('show-code') || 
            document.getElementById('code-content').contains(e.target)) {
            return;
        }
        
        if (e.target.closest('.list-group-item') || e.target.closest('.nav-item')) {
            document.getElementById('code-content').classList.add('d-none');
        }
    });

    init();
}); 