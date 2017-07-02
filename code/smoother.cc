#include <vector>
#include <iostream>

using std::vector;

namespace filter{
	class smoother {
		public:
			smoother(int coeff_num) : coeff_num_(coeff_num) {
				if(coeff_num_ < 1) coeff_num_ = 1;
				for(int i=0; i < coeff_num_; ++i) {
					coeff_.push_back(1.0 / coeff_num_);
					window_.push_back(0.0f);
				}
			}
		public:
			vector<float> coeff_;
			vector<float> window_;
			int coeff_num_;
			void filter(vector<float> &a);
	};

	void smoother::filter(vector<float> &a) {
		for(int i=0; i < a.size(); ++i) {
			float temp = 0.0f;
			window_[i % coeff_num_] = a[i];
		    for(int j=0 ;j < coeff_num_; ++j) {
		    	temp += coeff_[j] * window_[j];
		    }
		    a[i] = temp;
	    }
	}
}

int main() {
	vector<float> a;
	a.push_back(1.0f);
	a.push_back(2.0f);
	a.push_back(3.0f);
	a.push_back(100.0f);
	a.push_back(88.0f);
	a.push_back(1.0f);
	a.push_back(50.0f);
	a.push_back(0.0f);
	a.push_back(-1.0f);
	a.push_back(-1.0f);
	a.push_back(3.0f);

	filter::smoother s(5);
	s.filter(a);

	for(int i=0; i < a.size(); ++i) {
		std::cout << a[i] << " ";
	}
	std::cout << std::endl;
}